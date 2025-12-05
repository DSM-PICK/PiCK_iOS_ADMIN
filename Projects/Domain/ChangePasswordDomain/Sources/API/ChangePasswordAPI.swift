import Foundation
import Moya
import BaseDomain
import ChangePasswordDomainInterface

public enum ChangePasswordAPI {
    case changePassword(PasswordChangeRequestParams)
}

extension ChangePasswordAPI: PiCKAPI {
    public typealias ErrorType = ChangePasswordError

    public var domain: PiCKDomain {
        return .admin
    }

    public var urlPath: String {
        switch self {
        case .changePassword:
            return "/password"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .changePassword:
            return .put
        }
    }

    public var task: Moya.Task {
        switch self {
        case .changePassword(let params):
            return .requestJSONEncodable(params)
        }
    }

    public var pickHeader: TokenType {
        return .tokenIsEmpty
    }

    public var errorMap: [Int : ChangePasswordError]? {
        switch self {
        case .changePassword:
            return [
                400: .badRequest,
                404: .notFound,
                500: .serverError
            ]
        }
    }
}
