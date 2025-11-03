import Foundation
import Moya
import BaseDomain
import AuthDomainInterface

public enum AuthAPI {
    case signin(SigninRequestParams)
    case refreshToken
    case secretKey(SecretKeyRequestParams)
    case signup(SignupRequestParams)
}

public struct SigninResponseDTO: Decodable {
    let accessToken: String
    let refreshToken: String
    let accessExp: String
    let refreshExp: String
}

extension SigninResponseDTO {
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
        case .signin:
            return "/login"
        case .refreshToken:
            return "/reissue"
        case .secretKey:
            return "/key"
        case .signup:
            return "/signup"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .signin, .secretKey, .signup:
            return .post
        case .refreshToken:
            return .put
        }
    }

    public var task: Moya.Task {
        switch self {
        case .signin(let params):
            return .requestJSONEncodable(params)
        case .secretKey(let params):
            return .requestJSONEncodable(params)
        case .signup(let params):
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
        case .signin:
            return [
                401: .passwordMismatch,
                404: .idMismatch,
                500: .serverError
            ]
        case .secretKey, .signup:
            return [
                400: .clientError,
                403: .clientError,
                404: .clientError,
                500: .serverError
            ]
        default:
            return nil
        }
    }
}
