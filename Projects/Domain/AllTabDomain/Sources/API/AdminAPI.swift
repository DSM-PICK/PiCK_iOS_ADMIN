import Foundation
import BaseDomain
import Moya

public enum AdminAPI {
    case getMyName
}

extension AdminAPI: PiCKAPI {
    public typealias ErrorType = Never

    public var domain: BaseDomain.PiCKDomain {
        .admin
    }

    public var urlPath: String {
        switch self {
        case .getMyName:
            return "/my-name"
        }
    }

    public var method: Moya.Method {
        .get
    }

    public var task: Moya.Task {
        switch self {
        case .getMyName:
            return .requestPlain
        }
    }

    public var pickHeader: BaseDomain.TokenType {
        .accessToken
    }
    
    public var errorMap: [Int : ErrorType]? {
        return nil
    }
}
