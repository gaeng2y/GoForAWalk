import Foundation
import NetworkInterface

public final class NetworkProviderImpl: NetworkProvider {
    public static let shared = NetworkProviderImpl()
    
    public func request<N: Networkable, T: Decodable>(_ endpoint: N) async throws -> T where N.Response == T {
        do {
            let urlRequest: URLRequest = try endpoint.makeURLRequest(isBypass: false)
            print(urlRequest.url)
            let (data, response) = try await URLSession.shared.data(for: urlRequest, delegate: nil)
            guard let response = response as? HTTPURLResponse else {
                throw NetworkError.noResponse
            }
            
            print(urlRequest)
            
            if let requestBodyJsonString = String(data: urlRequest.httpBody ?? .SubSequence(), encoding: .utf8) {
                print(requestBodyJsonString)
            }
            
            if let responseJsonString = String(data: data, encoding: .utf8) {
                print("responseJsonString: \(responseJsonString)")
            }
            
            if let emptyResponse = try JSONDecoder().decode(EmptyData.self, from: data) as? T, data.isEmpty {
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
            case 401 :
                throw NetworkError.failedAuthorization
            case 400...499:
                throw NetworkError.badRequest
            case 500...599 :
                throw NetworkError.internalError
            default:
                throw NetworkError.unknownError
            }
            
        } catch URLError.Code.notConnectedToInternet {
            throw NetworkError.lostConnection
        }
    }
    
}
