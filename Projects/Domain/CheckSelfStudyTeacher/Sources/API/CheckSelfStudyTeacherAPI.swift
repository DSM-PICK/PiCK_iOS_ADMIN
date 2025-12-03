import Foundation
import BaseDomain
import Moya

public enum CheckSelfStudyTeacherAPI {
    case getSelfStudyTeacher(date: String)
}

extension CheckSelfStudyTeacherAPI: PiCKAPI {
    public typealias ErrorType = Never

    public var domain: BaseDomain.PiCKDomain {
        .selfStudy
    }

    public var urlPath: String {
        switch self {
        case .getSelfStudyTeacher:
            return "/today"
        }
    }

    public var method: Moya.Method {
        .get
    }

    public var task: Moya.Task {
        switch self {
        case let .getSelfStudyTeacher(date):
            return .requestParameters(
                parameters: ["date": date],
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
