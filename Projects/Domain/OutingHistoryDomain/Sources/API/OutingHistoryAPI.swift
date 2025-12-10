import Foundation
import BaseDomain
import Moya

public enum OutingHistoryAPI {
    case getOutingHistory
}

extension OutingHistoryAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var domain: BaseDomain.PiCKDomain {
        return .story
    }

    public var urlPath: String {
        return "/all"
    }

    public var method: Moya.Method {
        return .get
    }

    public var pickHeader: BaseDomain.TokenType {
        return .accessToken
    }

    public var task: Moya.Task {
        return .requestPlain
    }

    public var errorMap: [Int : BaseDomain.PiCKError]? {
        return nil
    }
}
