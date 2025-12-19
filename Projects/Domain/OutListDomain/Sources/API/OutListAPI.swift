import Foundation
import BaseDomain
import Moya

public enum OutListAPI {
    case getOutList(floor: Int)
    case returnStudents(ids: [String])
    case earlyReturnList(floor: Int, status: String)
}

extension OutListAPI: PiCKAPI {

    public typealias ErrorType = PiCKError
    
    public var domain: BaseDomain.PiCKDomain {
        switch self {
        case .earlyReturnList:
            return .earlyReturn
        default:
            return .application
        }
    }

    public var urlPath: String {
        switch self {
        case .getOutList:
            return "/floor"
        case .returnStudents:
            return "/return"
        case .earlyReturnList:
            return "/floor"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getOutList, .earlyReturnList:
            return .get
        case .returnStudents:
            return .patch
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .getOutList(floor):
            return .requestParameters(
                parameters: [
                    "floor": floor,
                    "status": "OK"
                ], encoding: URLEncoding.queryString
            )
        case let .returnStudents(ids):
            return .requestJSONEncodable(ids)
        case let .earlyReturnList(floor, status):
            return .requestParameters(
                parameters: [
                    "floor": floor,
                    "status": status
                ], encoding: URLEncoding.queryString
            )
        }
    }

    public var pickHeader: BaseDomain.TokenType {
        switch self {
        default:
            return .accessToken
        }
    }

    public var errorMap: [Int : BaseDomain.PiCKError]? {
        return nil
    }
}
