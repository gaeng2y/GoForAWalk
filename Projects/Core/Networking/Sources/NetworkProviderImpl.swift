import Foundation
import NetworkingInterface
import KeyChainStore

public final class NetworkProviderImpl: NetworkProvider {
    public static let shared = NetworkProviderImpl()

    private var isRefreshing = false
    private var refreshContinuations: [CheckedContinuation<Void, Error>] = []
    private let lock = NSLock()

    public func request<N: Networkable, T: Decodable>(_ endpoint: N) async throws -> T where N.Response == T {
        do {
            return try await performRequest(endpoint)
        } catch NetworkError.failedAuthorization {
            // 토큰 갱신 시도
            do {
                try await refreshTokenIfNeeded()
                // 갱신 성공 시 원래 요청 재시도
                return try await performRequest(endpoint)
            } catch {
                // 갱신 실패 시 세션 만료 알림
                handleSessionExpired()
                throw NetworkError.sessionExpired
            }
        }
    }

    public func requestWithoutRetry<N: Networkable, T: Decodable>(_ endpoint: N) async throws -> T where N.Response == T {
        return try await performRequest(endpoint)
    }

    private func performRequest<N: Networkable, T: Decodable>(_ endpoint: N) async throws -> T where N.Response == T {
        do {
            print("Creating URLRequest...")
            let isMultipart = endpoint.headers?["Content-Type"]?.contains("multipart/form-data") ?? false
            let urlRequest: URLRequest = isMultipart
                ? try endpoint.makeMultiPartURLRequest(isBypass: false)
                : try endpoint.makeURLRequest(isBypass: false)
            print("URLRequest created successfully")

            print("Headers: \(urlRequest.allHTTPHeaderFields ?? [:])")
            print("Body size: \(urlRequest.httpBody?.count ?? 0) bytes")

            print("Starting network request...")
            let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
            print("Network request completed")
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }

            print(urlRequest)

            if let requestBodyJsonString = String(data: urlRequest.httpBody ?? .SubSequence(), encoding: .utf8) {
                print(requestBodyJsonString)
            }

            return try handleResponse(data, httpResponse)

        } catch URLError.Code.notConnectedToInternet {
            throw NetworkError.lostConnection
        } catch let error as NetworkError {
            throw error
        } catch {
            print("Network error: \(error)")
            print("Error type: \(type(of: error))")
            if let urlError = error as? URLError {
                print("URLError code: \(urlError.code.rawValue)")
                print("URLError description: \(urlError.localizedDescription)")
            }
            throw error
        }
    }

    private func refreshTokenIfNeeded() async throws {
        lock.lock()
        if isRefreshing {
            // 이미 갱신 중이면 대기
            lock.unlock()
            try await withCheckedThrowingContinuation { (continuation: CheckedContinuation<Void, Error>) in
                lock.lock()
                refreshContinuations.append(continuation)
                lock.unlock()
            }
            return
        }
        isRefreshing = true
        lock.unlock()

        defer {
            lock.lock()
            isRefreshing = false
            let continuations = refreshContinuations
            refreshContinuations.removeAll()
            lock.unlock()

            for continuation in continuations {
                continuation.resume()
            }
        }

        // 토큰 갱신 실행
        let refreshToken = KeyChainStore.shared.load(property: .refreshToken)
        guard !refreshToken.isEmpty else {
            throw NetworkError.sessionExpired
        }

        guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String,
              let prefix = Bundle.main.infoDictionary?["BASE_URL_PREFIX"] as? String,
              let url = URL(string: baseURL + prefix + "auth/token/refresh") else {
            throw NetworkError.invalidURL
        }

        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        urlRequest.setValue("Bearer \(refreshToken)", forHTTPHeaderField: "Authorization")
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")

        let (data, response) = try await URLSession.shared.data(for: urlRequest)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noResponse
        }

        guard httpResponse.statusCode == 200 else {
            throw NetworkError.sessionExpired
        }

        // 새 토큰 파싱 및 저장
        let decoder = JSONDecoder()
        let tokenResponse = try decoder.decode(TokenRefreshResponse.self, from: data)

        KeyChainStore.shared.save(property: .accessToken, value: tokenResponse.data.credentials.accessToken)
        KeyChainStore.shared.save(property: .refreshToken, value: tokenResponse.data.credentials.refreshToken)
        KeyChainStore.shared.save(property: .userIdentifier, value: "\(tokenResponse.data.userId)")
    }

    private func handleSessionExpired() {
        KeyChainStore.shared.deleteAll()
        SessionExpiredNotifier.notifySessionExpired()
    }

    private func handleResponse<T: Decodable>(
        _ data: Data,
        _ response: HTTPURLResponse
    ) throws -> T {
        if let responseJsonString = String(data: data, encoding: .utf8) {
            print("responseJsonString: \(responseJsonString)")
        }

        if data.isEmpty, let emptyResponse = EmptyData() as? T {
            return emptyResponse
        }

        print(response.statusCode)
        switch response.statusCode {
        case 200...299:
            do {
                let decodedResponse = try JSONDecoder().decode(ResponseData<T>.self, from: data)
                return decodedResponse.data
            } catch {
                print(error)
                throw NetworkError.failedDecoding
            }
        case 401:
            throw NetworkError.failedAuthorization
        case 400...499:
            throw NetworkError.badRequest
        case 500...599:
            throw NetworkError.internalError
        default:
            throw NetworkError.unknownError
        }
    }
}

private struct TokenRefreshResponse: Decodable {
    struct Data: Decodable {
        let userId: Int
        let credentials: Credentials
    }

    struct Credentials: Decodable {
        let accessToken: String
        let refreshToken: String
    }

    let data: Data
}
