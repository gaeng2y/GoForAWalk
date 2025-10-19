import Foundation
import NetworkingInterface
import KeyChainStore

public final class NetworkProviderImpl: NetworkProvider {
    public static let shared = NetworkProviderImpl()
    
    public func request<N: Networkable, T: Decodable>(_ endpoint: N) async throws -> T where N.Response == T {
        do {
            print("Creating URLRequest...")
            // multipart 요청인지 확인
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
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            
            print(urlRequest)
            
            if let requestBodyJsonString = String(data: urlRequest.httpBody ?? .SubSequence(), encoding: .utf8) {
                print(requestBodyJsonString)
            }
            
            return try handleResponse(data, response)
            
        } catch URLError.Code.notConnectedToInternet {
            throw NetworkError.lostConnection
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
            KeyChainStore.shared.deleteAll()
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
