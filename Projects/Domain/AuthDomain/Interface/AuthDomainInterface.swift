import Foundation
import RxSwift

// MARK: - UseCases
public protocol LoginUseCase {
    func execute(req: LoginRequestParams) -> Completable
}

public protocol RefreshTokenUseCase {
    func execute() -> Completable
}

// MARK: - Repository
public protocol AuthRepository {
    func login(req: LoginRequestParams) -> Completable
    func refreshToken() -> Completable
}

// MARK: - Parameters
public struct LoginRequestParams: Encodable {
    public let adminId: String
    public let password: String
    public let deviceToken: String

    public init(
        adminId: String,
        password: String,
        deviceToken: String
    ) {
        self.adminId = adminId
        self.password = password
        self.deviceToken = deviceToken
    }

    enum CodingKeys: String, CodingKey {
        case adminId = "admin_id"
        case password
        case deviceToken = "device_token"
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
