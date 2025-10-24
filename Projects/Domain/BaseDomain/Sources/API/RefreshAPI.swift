import Moya

public enum RefreshAPI {
    case refreshToken
}

extension RefreshAPI: PiCKAPI {
    public typealias ErrorType = RefreshError

    public var domain: PiCKDomain {
        .admin
    }

    public var urlPath: String {
        switch self {
        case .refreshToken:
            return "/refresh"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .refreshToken:
            return .put
        }
    }

    public var task: Moya.Task {
        switch self {
        default:
            return .requestPlain
        }
    }

    public var pickHeader: TokenType {
        switch self {
        case .refreshToken:
            return .refreshToken
        }
    }

    public var errorMap: [Int : ErrorType]? {
        switch self {
        case .refreshToken:
            return [
                401: .unauthorized,
                404: .unauthorized
            ]
        }
    }
}
