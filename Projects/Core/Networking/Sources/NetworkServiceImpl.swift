//
//  NetworkServiceImpl.swift
//  Networking
//
//  Created by Kyeongmo Yang on 12/17/25.
//  Copyright © 2025 com.gaeng2y. All rights reserved.
//

import Alamofire
import Foundation
import KeyChainStoreInterface
import NetworkingInterface

// MARK: - NetworkServiceImpl

/// NetworkService 프로토콜의 Alamofire 기반 구현체
///
/// **역할과 책임:**
/// - NetworkService 인터페이스의 구체적인 구현을 제공
/// - Alamofire를 사용한 실제 HTTP 요청 수행
/// - 서버 응답을 적절한 Swift 모델로 변환하여 반환
/// - Clean Architecture의 Data Layer에서 Infrastructure 역할 담당
///
/// **의존성 주입 패턴:**
/// - Alamofire Session을 외부에서 주입받아 사용 (Dependency Injection)
/// - 테스트 시 Mock Session을 주입하여 단위 테스트 가능
/// - 실제 운영 시에는 실제 Alamofire Session 사용
///
/// **Swift 6 Concurrency 호환성:**
/// - final 키워드로 상속 방지하여 성능 최적화
/// - private 프로퍼티로 내부 상태 캡슐화
/// - async/await 패턴으로 안전한 비동기 처리
///
/// **사용 시나리오 예시:**
/// ```swift
/// // 1. 기본 사용 (프로덕션)
/// let networkService = NetworkServiceImpl()
/// let userData: UserModel = try await networkService.request(UserEndpoint.getProfile)
///
/// // 2. 커스텀 세션 설정
/// let customSession = Session(configuration: customConfig)
/// let networkService = NetworkServiceImpl(session: customSession)
/// ```
///
/// - Note: 이 클래스는 참조 타입(class)으로 설계되었습니다.
///         Session 객체의 생명주기 관리와 네트워크 연결 풀 공유를 위해
///         값 타입(struct) 대신 참조 타입을 사용합니다.
public final class NetworkServiceImpl: NetworkService {
    
    // MARK: - Properties
    
    private let session: Alamofire.Session
    
    // MARK: - Initialization
    
    /// KeychainStore를 주입받아 AuthorizationInterceptor와 함께 초기화합니다
    ///
    /// - Parameter keychainStore: 토큰 저장소
    public init(keychainStore: KeychainStore) {
        let interceptor = AuthorizationInterceptor(keychainStore: keychainStore)
        self.session = Self.configureAFSession(interceptor: interceptor)
    }
    
    /// 테스트용: Session을 직접 주입받아 초기화합니다
    ///
    /// - Parameter session: HTTP 요청을 처리할 Alamofire Session 인스턴스
    public init(session: Alamofire.Session) {
        self.session = session
    }
    
    // MARK: - Session Configuration
    
    /// 프로덕션 환경에 최적화된 Alamofire Session을 구성합니다
    ///
    /// **네트워크 설정:**
    /// - `timeoutIntervalForRequest`: 60초 - 개별 요청의 최대 대기 시간
    /// - `timeoutIntervalForResource`: 120초 - 전체 리소스 다운로드 최대 시간
    /// - `waitsForConnectivity`: true - 네트워크 복구 시 자동 재시도
    /// - `httpMaximumConnectionsPerHost`: 5개 - 동시 연결 제한으로 서버 부하 방지
    ///
    /// **캐시 전략:**
    /// - `requestCachePolicy`: .useProtocolCachePolicy - HTTP 헤더 기반 캐싱
    /// - 메모리 캐시: 50MB - 빠른 응답을 위한 RAM 캐시
    /// - 디스크 캐시: 200MB - 앱 재시작 후에도 유지되는 영구 캐시
    ///
    /// **모니터링:**
    /// - APIEventLogger를 통한 요청/응답 로깅
    ///
    /// - Parameter interceptor: 인증 헤더 주입 및 토큰 갱신을 담당하는 Interceptor
    /// - Returns: 최적화된 설정이 적용된 Alamofire.Session 인스턴스
    private static func configureAFSession(interceptor: AuthorizationInterceptor) -> Alamofire.Session {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 60
        configuration.timeoutIntervalForResource = 120
        configuration.waitsForConnectivity = true
        configuration.httpMaximumConnectionsPerHost = 5
        
        // 캐시 설정
        configuration.requestCachePolicy = .useProtocolCachePolicy
        configuration.urlCache = URLCache(
            memoryCapacity: 50 * 1024 * 1024,
            diskCapacity: 200 * 1024 * 1024,
            diskPath: "GoForAWalkCache"
        )
        
        #if DEBUG
        let monitors: [EventMonitor] = [APIEventLogger()]
        #else
        let monitors: [EventMonitor] = []
        #endif
        
        return Alamofire.Session(
            configuration: configuration,
            interceptor: interceptor,
            eventMonitors: monitors
        )
    }
    
    // MARK: - NetworkService Implementation
    
    /// 서버에 API 요청을 전송하고 응답을 Swift 모델로 변환하여 반환합니다
    ///
    /// **구현 세부사항:**
    /// 1. HTTPTask 타입에 따라 일반 요청 또는 Multipart 업로드 분기
    /// 2. Alamofire Session을 통해 HTTP 요청 수행
    /// 3. HTTP 상태 코드 200-299 범위 검증
    /// 4. 서버 응답을 지정된 제네릭 타입 T로 자동 디코딩
    ///
    /// - Parameter endpoint: 요청할 API 엔드포인트 (Endpoint 프로토콜 구현체)
    /// - Returns: 제네릭 T 타입의 Swift 모델 객체
    /// - Throws: NetworkError - 네트워크 또는 디코딩 실패 시
    public func request<T: Decodable>(_ endpoint: any Endpoint) async throws -> T {
        switch endpoint.task {
        case .requestPlain, .requestParameters, .requestEncodable:
            // 일반 요청 처리
            return try await performRequest(endpoint)
        case .uploadMultipart(let items):
            // Multipart 업로드인 경우 별도 처리
            return try await uploadMultipart(endpoint, items: items)
        }
    }
    
    // MARK: - Private Methods
    
    /// 일반 HTTP 요청을 수행합니다
    private func performRequest<T: Decodable>(_ endpoint: any Endpoint) async throws -> T {
        let urlRequest = try endpoint.asURLRequest()
        let dataRequest = session.request(urlRequest)
            .validate(statusCode: 200..<300)
        
        let result = await dataRequest.serializingDecodable(T.self).result
        
        switch result {
        case .success(let value):
            return value
        case .failure(let afError):
            throw mapToNetworkError(afError, from: dataRequest.data)
        }
    }
    
    /// Multipart Form Data를 사용하여 파일을 업로드합니다
    ///
    /// **처리 순서:**
    /// 1. Endpoint에서 URLRequest 생성 (URL, Method, Headers)
    /// 2. MultipartFormItem 배열을 Alamofire MultipartFormData로 변환
    /// 3. Alamofire upload 메서드로 업로드 수행
    /// 4. 응답 검증 및 디코딩
    ///
    /// - Parameters:
    ///   - endpoint: 업로드할 API 엔드포인트
    ///   - items: Multipart로 전송할 데이터 항목들
    /// - Returns: 서버 응답을 디코딩한 객체
    /// - Throws: NetworkError - 업로드 실패 시
    private func uploadMultipart<T: Decodable>(
        _ endpoint: any Endpoint,
        items: [MultipartFormItem]
    ) async throws -> T {
        let urlRequest = try endpoint.asURLRequest()
        
        let uploadRequest = session.upload(
            multipartFormData: { formData in
                for item in items {
                    if let fileName = item.fileName, let mimeType = item.mimeType {
                        // 파일 데이터 (이미지, 동영상 등)
                        formData.append(
                            item.data,
                            withName: item.name,
                            fileName: fileName,
                            mimeType: mimeType
                        )
                    } else {
                        // 텍스트 필드
                        formData.append(item.data, withName: item.name)
                    }
                }
            },
            with: urlRequest
        )
            .validate(statusCode: 200..<300)
        
        let result = await uploadRequest.serializingDecodable(T.self).result
        
        switch result {
        case .success(let value):
            return value
        case .failure(let afError):
            throw mapToNetworkError(afError, from: uploadRequest.data)
        }
    }
    
    // MARK: - Error Mapping
    
    /// Alamofire의 AFError를 앱에서 정의한 NetworkError로 변환합니다
    ///
    /// **주요 변환 케이스:**
    /// - `responseValidationFailed(.unacceptableStatusCode(401))` → `.unauthorized`
    /// - `responseValidationFailed(.missingContentType)` → `.missingContentType`
    /// - `responseSerializationFailed` → `.decodingFailed`
    /// - `URLError` → `.networkConnection`
    ///
    /// - Parameters:
    ///   - afError: Alamofire에서 발생한 원본 에러
    ///   - data: 응답과 함께 전달된 데이터
    /// - Returns: 앱 도메인에 맞게 분류된 NetworkError 인스턴스
    private func mapToNetworkError(_ afError: AFError, from data: Data?) -> NetworkError {
        // 네트워크 연결 관련 에러인지 확인
        if let underlyingError = afError.underlyingError as? URLError {
            return .networkConnection(underlyingError)
        }
        
        switch afError {
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code):
                if code == 401 {
                    return .unauthorized
                } else {
                    return .unacceptableStatusCode(code: code, data: data)
                }
                
            case .missingContentType(let acceptableContentTypes):
                return .missingContentType(acceptableTypes: acceptableContentTypes)
                
            case let .unacceptableContentType(acceptableContentTypes, responseContentType):
                return .unacceptableContentType(
                    expected: acceptableContentTypes,
                    actual: responseContentType
                )
                
            case .dataFileNil:
                return .dataFileNotFound
                
            case .dataFileReadFailed(let url):
                return .dataFileReadFailed(url: url)
                
            default:
                return .unknown(afError)
            }
            
        case .responseSerializationFailed:
            return .decodingFailed(afError)
            
        default:
            return .unknown(afError)
        }
    }
}

// MARK: - APIEventLogger

/// 네트워크 요청 및 응답을 로깅하는 EventMonitor 구현체
///
/// **주요 기능:**
/// - HTTP 요청 정보 로깅: URL, Method, Headers, Body
/// - HTTP 응답 정보 로깅: StatusCode, Result, ResponseData
/// - JSON 응답 데이터 Pretty Print 출력
///
/// **사용 목적:**
/// - 개발 단계에서의 API 디버깅 지원
/// - 네트워크 요청 흐름 추적 및 문제점 파악
///
/// - Note: DEBUG 빌드에서만 활성화됩니다.
private final class APIEventLogger: EventMonitor {
    /// 로깅 작업을 위한 전용 큐
    fileprivate let queue = DispatchQueue(label: "GoForAWalk.APIEventLogger")
    
    /// 네트워크 요청이 완료된 후 호출되어 요청 정보를 로깅합니다
    func requestDidFinish(_ request: Request) {
        debugPrint("🛜 NETWORK Request LOG")
        debugPrint(request.description)
        
        debugPrint(
            "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "Method: " + (request.request?.httpMethod ?? "") + "\n"
            + "Headers: " + "\(request.request?.allHTTPHeaderFields ?? [:])" + "\n"
        )
        debugPrint("Authorization: " + (request.request?.headers["Authorization"] ?? ""))
        debugPrint("Body: " + (request.request?.httpBody?.toPrettyPrintedString ?? ""))
    }
    
    /// 네트워크 응답이 파싱된 후 호출되어 응답 정보를 로깅합니다
    func request<Value>(
        _ request: DataRequest,
        didParseResponse response: DataResponse<Value, AFError>
    ) {
        debugPrint("🛜 NETWORK Response LOG")
        debugPrint(
            "URL: " + (request.request?.url?.absoluteString ?? "") + "\n"
            + "Result: " + "\(response.result)" + "\n"
            + "StatusCode: " + "\(response.response?.statusCode ?? 0)" + "\n"
            + "Data: \(response.data?.toPrettyPrintedString ?? "")"
        )
    }
}

// MARK: - Data Extension

/// Data 타입에 JSON Pretty Print 기능을 추가하는 확장
private extension Data {
    /// JSON 데이터를 읽기 쉬운 형태로 포맷팅된 문자열로 변환합니다
    var toPrettyPrintedString: String? {
        guard let object = try? JSONSerialization.jsonObject(with: self, options: []),
              let data = try? JSONSerialization.data(withJSONObject: object, options: [.prettyPrinted]),
              let prettyPrintedString = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else {
            return nil
        }
        return prettyPrintedString as String
    }
}
