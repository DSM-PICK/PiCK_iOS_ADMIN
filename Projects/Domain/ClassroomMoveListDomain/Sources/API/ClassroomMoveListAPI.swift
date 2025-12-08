import Foundation
import BaseDomain
import Moya

public enum ClassroomMoveListAPI {
    case getClassroomMoveByFloor(floor: Int)
    case getClasssroomMoveByClassroom(grade: Int, classNum: Int)
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
        case .getClasssroomMoveByClassroom:
            return "/grade"
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
        case let .getClasssroomMoveByClassroom(grade, classNum):
            return .requestParameters(
                parameters: [
                    "grade": grade,
                    "class_num": classNum
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
