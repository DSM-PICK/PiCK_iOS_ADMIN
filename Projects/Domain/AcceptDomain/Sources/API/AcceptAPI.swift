import Foundation
import BaseDomain
import Moya

public enum AcceptAPI {
    case getAllApplications
}

extension AcceptAPI: PiCKAPI {
    public typealias ErrorType = Never

    public var domain: BaseDomain.PiCKDomain {
        .application
    }

    public var urlPath: String {
        switch self {
        case .getAllApplications:
            return "/reason/all"
        }
    }

    public var method: Moya.Method {
        .get
    }

    public var task: Moya.Task {
        switch self {
        case .getAllApplications:
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
