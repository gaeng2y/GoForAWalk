import Foundation
import NetworkingInterface
@testable import Networking
import XCTest

final class NetworkTests: XCTestCase {
    private struct StubBody: Codable, Sendable, Equatable {
        let title: String
        let count: Int
    }

    private struct FailingBody: Encodable, Sendable {
        struct ExpectedError: Error {}

        func encode(to encoder: Encoder) throws {
            throw ExpectedError()
        }
    }

    private struct StubEndpoint: Endpoint {
        let baseURL: URL
        let path: String
        let method: NetworkingMethod
        let authRequirement: AuthRequirement
        let customHeaders: [String: String]?
        let task: HTTPTask

        init(
            baseURL: URL = URL(string: "https://example.com/api")!,
            path: String = "resource",
            method: NetworkingMethod = .get,
            authRequirement: AuthRequirement = .none,
            customHeaders: [String: String]? = nil,
            task: HTTPTask = .requestPlain
        ) {
            self.baseURL = baseURL
            self.path = path
            self.method = method
            self.authRequirement = authRequirement
            self.customHeaders = customHeaders
            self.task = task
        }
    }

    func testAsURLRequestRequestParametersEncodesQueryItems() throws {
        let endpoint = StubEndpoint(
            path: "footsteps",
            task: .requestParameters([
                "page": "1",
                "size": "20"
            ])
        )

        let request = try endpoint.asURLRequest()
        let url = try XCTUnwrap(request.url)
        let components = try XCTUnwrap(URLComponents(url: url, resolvingAgainstBaseURL: false))
        let queryItems = components.queryItems ?? []
        let queryDictionary = Dictionary(
            uniqueKeysWithValues: queryItems.map { ($0.name, $0.value ?? "") }
        )

        XCTAssertEqual(queryDictionary["page"], "1")
        XCTAssertEqual(queryDictionary["size"], "20")
        XCTAssertEqual(request.httpMethod, "GET")
    }

    func testAsURLRequestBearerAuthAddsMarkerHeader() throws {
        let endpoint = StubEndpoint(
            path: "secure",
            authRequirement: .bearer
        )

        let request = try endpoint.asURLRequest()

        XCTAssertEqual(
            request.value(forHTTPHeaderField: "X-Requires-Auth"),
            "bearer"
        )
    }

    func testAsURLRequestRequestEncodableSetsJSONBodyAndDefaultContentType() throws {
        let body = StubBody(title: "walk", count: 2)
        let endpoint = StubEndpoint(
            path: "posts",
            method: .post,
            task: .requestEncodable(body)
        )

        let request = try endpoint.asURLRequest()
        let encodedData = try XCTUnwrap(request.httpBody)
        let decodedBody = try JSONDecoder().decode(StubBody.self, from: encodedData)

        XCTAssertEqual(decodedBody, body)
        XCTAssertEqual(
            request.value(forHTTPHeaderField: "Content-Type"),
            "application/json"
        )
        XCTAssertEqual(request.httpMethod, "POST")
    }

    func testAsURLRequestRequestEncodableKeepsCustomContentType() throws {
        let endpoint = StubEndpoint(
            path: "posts",
            method: .post,
            customHeaders: [
                "Content-Type": "application/vnd.api+json"
            ],
            task: .requestEncodable(StubBody(title: "custom", count: 1))
        )

        let request = try endpoint.asURLRequest()

        XCTAssertEqual(
            request.value(forHTTPHeaderField: "Content-Type"),
            "application/vnd.api+json"
        )
    }

    func testAsURLRequestRequestEncodableWhenEncodingFailsThrowsEncodingFailed() {
        let endpoint = StubEndpoint(
            path: "posts",
            method: .post,
            task: .requestEncodable(FailingBody())
        )

        XCTAssertThrowsError(try endpoint.asURLRequest()) { error in
            guard case NetworkError.encodingFailed = error else {
                XCTFail("Expected NetworkError.encodingFailed, got \(error)")
                return
            }
        }
    }
}
