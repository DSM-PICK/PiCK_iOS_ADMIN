import Foundation
import Combine

// MARK: - UseCases
public protocol LoginUseCase {
    func execute(req: LoginRequestParams) -> AnyPublisher<Void, Error>
}

public protocol RefreshTokenUseCase {
    func execute() -> AnyPublisher<Void, Error>
}

public protocol RemoteAuthDataSource {
    func login(req: LoginRequestParams) -> AnyPublisher<TokenDTO, Error>
    func refreshToken() -> AnyPublisher<TokenDTO, Error>
}

public protocol AuthRepository {
    func login(req: LoginRequestParams) -> AnyPublisher<Void, Error>
    func refreshToken() -> AnyPublisher<Void, Error>
    func logout()
}

public protocol LocalAuthDataSource {
    func logout()
}

public struct LoginRequestParams: Encodable {
    public let adminID: String
    public let password: String
    public let deviceToken: String

    public init(
        adminID: String,
        password: String,
        deviceToken: String
    ) {
        self.adminID = adminID
        self.password = password
        self.deviceToken = deviceToken
    }

    enum CodingKeys: String, CodingKey {
        case adminID = "admin_id"
        case password
        case deviceToken = "device_token"
    }
}


// MARK: - Entities
public struct TokenEntity: Equatable {
    public let accessToken: String
    public let refreshToken: String
    public init(accessToken: String, refreshToken: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
    }
}

// MARK: - Repository



public struct TokenDTO: Codable {
    public let accessToken: String
    public let refreshToken: String

    enum CodingKeys: String, CodingKey {
        case accessToken = "access_token"
        case refreshToken = "refresh_token"
    }
}

// MARK: - Errors
public enum AuthError: Error {
    case idMismatch
    case passwordMismatch
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .idMismatch:
            return "올바른 아이디를 입력해주세요"
        case .passwordMismatch:
            return "올바른 비밀번호를 입력해주세요"
        }
    }
}

public enum PiCKError: Error {
    case error(message: String = "에러가 발생했습니다.", errorBody: [String: Any] = [:])
    case serverError
}

extension PiCKError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case let .error(message, _):
            return message
        case .serverError:
            return "서버 에러가 발생했습니다."
        }
    }
}
