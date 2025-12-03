import Foundation
import BaseDomain
import Moya

public enum OutListAPI {
    case getOutList(floor: Int)
}

extension OutListAPI: PiCKAPI {

    public typealias ErrorType = PiCKError
    
    public var domain: BaseDomain.PiCKDomain {
        return .application
    }
    
    public var urlPath: String {
        switch self {
        case .getOutList:
            return "/floor"
        }
    }
    
    public var method: Moya.Method {
        switch self {
        case .getOutList:
            return .get
        }
    }
    
    public var task: Moya.Task {
        switch self {
        case let .getOutList(floor):
            return .requestParameters(
                parameters: [
                    "floor": floor,
                    "state": "OK"
                ], encoding: URLEncoding.queryString
            )
        }
    }

    public var pickHeader: BaseDomain.TokenType {
        switch self {
        case .getOutList:
            return .accessToken
        }
    }

    public var errorMap: [Int : BaseDomain.PiCKError]? {
        return nil
    }
}
