import KeyChainStoreInterface
@testable import KeyChainStore
import XCTest

final class KeyChainStoreTests: XCTestCase {
    private struct TokenSnapshot {
        let accessToken: String?
        let refreshToken: String?
    }

    private var store: KeychainStoreImpl {
        .shared
    }

    func testSaveThenLoadReturnsSavedTokenValue() async throws {
        try await withIsolatedKeychain { store in
            await store.save(property: .accessToken, value: "test-access-token")

            let loaded = try await store.load(property: .accessToken)

            XCTAssertEqual(loaded, "test-access-token")
        }
    }

    func testSaveTwiceOverridesExistingValue() async throws {
        try await withIsolatedKeychain { store in
            await store.save(property: .accessToken, value: "old-token")
            await store.save(property: .accessToken, value: "new-token")

            let loaded = try await store.load(property: .accessToken)

            XCTAssertEqual(loaded, "new-token")
        }
    }

    func testDeleteAllRemovesAllTokenProperties() async throws {
        try await withIsolatedKeychain { store in
            await store.save(property: .accessToken, value: "access-token")
            await store.save(property: .refreshToken, value: "refresh-token")

            await store.deleteAll()

            await assertItemNotFound(
                from: store,
                property: .accessToken
            )
            await assertItemNotFound(
                from: store,
                property: .refreshToken
            )
        }
    }

    func testLoadWhenNoStoredItemThrowsItemNotFound() async throws {
        try await withIsolatedKeychain { store in
            await assertItemNotFound(
                from: store,
                property: .accessToken
            )
        }
    }

    private func withIsolatedKeychain(
        _ operation: (KeychainStoreImpl) async throws -> Void
    ) async throws {
        let snapshot = await snapshotCurrentTokens()

        await store.deleteAll()
        do {
            try await operation(store)
        } catch {
            await restoreTokens(from: snapshot)
            throw error
        }

        await restoreTokens(from: snapshot)
    }

    private func snapshotCurrentTokens() async -> TokenSnapshot {
        let accessToken = try? await store.load(property: .accessToken)
        let refreshToken = try? await store.load(property: .refreshToken)

        return TokenSnapshot(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }

    private func restoreTokens(from snapshot: TokenSnapshot) async {
        await store.deleteAll()

        if let accessToken = snapshot.accessToken {
            await store.save(property: .accessToken, value: accessToken)
        }
        if let refreshToken = snapshot.refreshToken {
            await store.save(property: .refreshToken, value: refreshToken)
        }
    }

    private func assertItemNotFound(
        from store: KeychainStoreImpl,
        property: TokenProperty,
        file: StaticString = #filePath,
        line: UInt = #line
    ) async {
        do {
            _ = try await store.load(property: property)
            XCTFail("Expected itemNotFound error for \(property)", file: file, line: line)
        } catch let keychainError {
            guard case .itemNotFound = keychainError else {
                XCTFail(
                    "Expected itemNotFound error, got \(keychainError)",
                    file: file,
                    line: line
                )
                return
            }
        }
    }
}
