import Foundation
import Moya
import BaseDomain
import AuthDomainInterface

public enum AuthAPI {
    case login(LoginRequestParams)
    case refreshToken
}

public struct LoginResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let accessExp: String
    let refreshExp: String
}

extension LoginResponseDTO {
    func toDomain() -> TokenEntity {
        .init(
            accessToken: accessToken,
            refreshToken: refreshToken
        )
    }
}

extension AuthAPI: PiCKAPI {
    public typealias ErrorType = AuthError

    public var domain: PiCKDomain {
        return .admin
    }

    public var urlPath: String {
        switch self {
        case .login:
            return "/admin/auth/login"
        case .refreshToken:
            return "/admin/auth/reissue"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .login:
            return .post
        case .refreshToken:
            return .put
        }
    }

    public var task: Moya.Task {
        switch self {
        case .login(let params):
            return .requestJSONEncodable(params)
        default:
            return .requestPlain
        }
    }

    public var pickHeader: TokenType {
        switch self {
        case .refreshToken:
            return .refreshToken
        default:
            return .tokenIsEmpty
        }
    }

    public var errorMap: [Int : AuthDomainInterface.AuthError]? {
        switch self {
        case .login(let req):
            return [
                401: .passwordMismatch,
                404: .idMismatch
            ]
        default:
            return nil
        }
    }
}
