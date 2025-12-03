import XCTest
import Combine
import Moya
@testable import BaseDomain
@testable import AuthDomain
@testable import Core

final class MockKeychain: Keychain {
    private var storage: [KeychainType: String] = [:]

    func save(type: KeychainType, value: String) {
        storage[type] = value
    }

    func load(type: KeychainType) -> String {
        return storage[type] ?? ""
    }

    func delete(type: KeychainType) {
        storage.removeValue(forKey: type)
    }

    func clear() {
        storage.removeAll()
    }
}

final class RefreshTokenTests: XCTestCase {
    var cancellables: Set<AnyCancellable>!
    var mockKeychain: MockKeychain!
    var jwtStore: JwtStore!

    override func setUpWithError() throws {
        cancellables = []
        mockKeychain = MockKeychain()
        jwtStore = JwtStore(keychain: mockKeychain)
    }

    override func tearDownWithError() throws {
        cancellables = nil
        jwtStore.clearTokens()
        mockKeychain = nil
        jwtStore = nil
    }

    func testJwtStore_SaveAndLoadAccessToken() throws {
        let testToken = "test-access-token-123"
        jwtStore.accessToken = testToken
        XCTAssertEqual(jwtStore.accessToken, testToken)
    }

    func testJwtStore_SaveAndLoadRefreshToken() throws {
        let testToken = "test-refresh-token-456"
        jwtStore.refreshToken = testToken
        XCTAssertEqual(jwtStore.refreshToken, testToken)
    }

    func testJwtStore_ClearTokens() throws {
        jwtStore.accessToken = "access-token"
        jwtStore.refreshToken = "refresh-token"
        jwtStore.clearTokens()
        XCTAssertNil(jwtStore.accessToken)
        XCTAssertNil(jwtStore.refreshToken)
    }

    func testJwtStore_HasValidToken_WhenBothTokensExist() throws {
        jwtStore.accessToken = "access-token"
        jwtStore.refreshToken = "refresh-token"
        XCTAssertTrue(jwtStore.hasValidToken)
    }

    func testJwtStore_HasValidToken_WhenTokensMissing() throws {
        jwtStore.clearTokens()
        XCTAssertFalse(jwtStore.hasValidToken)
    }

    func testJwtStore_ToHeader_AccessToken() throws {
        let testToken = "test-access-token"
        jwtStore.accessToken = testToken
        let headers = jwtStore.toHeader(.accessToken)
        XCTAssertEqual(headers["Authorization"], "Bearer \(testToken)")
        XCTAssertEqual(headers["content-type"], "application/json")
    }

    func testJwtStore_ToHeader_RefreshToken() throws {
        let testToken = "test-refresh-token"
        jwtStore.refreshToken = testToken
        let headers = jwtStore.toHeader(.refreshToken)
        XCTAssertEqual(headers["X-Refresh-Token"], testToken)
        XCTAssertEqual(headers["content-type"], "application/json")
    }

    func testJwtStore_RemovesBearerPrefix_WhenSaving() throws {
        let tokenWithPrefix = "Bearer test-token-789"
        jwtStore.accessToken = tokenWithPrefix
        XCTAssertEqual(jwtStore.accessToken, "test-token-789")
    }
}
