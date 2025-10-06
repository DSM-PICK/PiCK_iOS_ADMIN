import Foundation
import Moya
import AuthDomainInterface
import Utility

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
            refreshToken: refreshToken,
            accessExp: accessExp,
            refreshExp: refreshExp
        )
    }
}

extension AuthAPI: TargetType {
    public var baseURL: URL {
        return URLUtil.baseURL
    }

    public var path: String {
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

    public var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
