import Foundation
import BaseDomain
import Moya

public enum AcceptAPI {
    case getApplicationsByGrade(grade: Int, classNum: Int)
}

extension AcceptAPI: PiCKAPI {
    public typealias ErrorType = Never

    public var domain: BaseDomain.PiCKDomain {
        .application
    }

    public var urlPath: String {
        switch self {
        case .getApplicationsByGrade:
            return "/grade"
        }
    }

    public var method: Moya.Method {
        .get
    }

    public var task: Moya.Task {
        switch self {
        case let .getApplicationsByGrade(grade, classNum):
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
        .accessToken
    }

    public var errorMap: [Int : ErrorType]? {
        return nil
    }
}
