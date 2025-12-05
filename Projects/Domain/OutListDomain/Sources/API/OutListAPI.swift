import Foundation
import BaseDomain
import Moya

public enum OutListAPI {
    case getOutList(floor: Int)
    case returnStudents(ids: [String])
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
        case .returnStudents:
            return "/return"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getOutList:
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
