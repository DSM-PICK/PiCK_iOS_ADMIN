import Foundation
import BaseDomain
import Moya

public enum ClassroomMoveListAPI {
    case getClassroomMoveByFloor(floor: Int)
}

extension ClassroomMoveListAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var domain: BaseDomain.PiCKDomain {
        return .classroom
    }

    public var urlPath: String {
        switch self {
        case .getClassroomMoveByFloor:
            return "/floor"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case let .getClassroomMoveByFloor(floor):
            return .requestParameters(
                parameters: [
                    "floor": floor,
                    "status": "OK"
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var pickHeader: BaseDomain.TokenType {
        return .accessToken
    }

    public var errorMap: [Int : BaseDomain.PiCKError]? {
        return .none
    }
}
