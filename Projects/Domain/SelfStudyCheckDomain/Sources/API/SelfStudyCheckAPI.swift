import Foundation
import BaseDomain
import Moya

public enum SelfStudyCheckAPI {
    case getStudentAttendance(grade: Int, classNum: Int, period: Int)
    case modifyAttendance(period: Int, attendances: [AttendanceUpdateRequestDTO])
}

extension SelfStudyCheckAPI: PiCKAPI {

    public typealias ErrorType = PiCKError

    public var domain: BaseDomain.PiCKDomain {
        return .attendance
    }

    public var urlPath: String {
        switch self {
        case .getStudentAttendance:
            return "/grade"
        case .modifyAttendance:
            return "/modify"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getStudentAttendance:
            return .get
        case .modifyAttendance:
            return .patch
        }
    }

    public var task: Moya.Task {
        switch self {
        case let .getStudentAttendance(grade, classNum, period):
            return .requestParameters(
                parameters: [
                    "grade": grade,
                    "class_num": classNum,
                    "period": period
                ], encoding: URLEncoding.queryString
            )
        case let .modifyAttendance(period, attendances):
            let data = try? JSONEncoder().encode(attendances)
            return .requestCompositeData(
                bodyData: data ?? Data(),
                urlParameters: ["period": period]
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
