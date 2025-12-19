import Foundation
import BaseDomain
import Moya

public enum MainAPI {
    case getSelfStudyDirector(date: String)
    case getAdminSelfStudyInfo
    case getSelfStudyAndClassroom
}

extension MainAPI: PiCKAPI {
    public typealias ErrorType = Never

    public var domain: BaseDomain.PiCKDomain {
        switch self {
        case .getAdminSelfStudyInfo, .getSelfStudyDirector:
            return .selfStudy
        case .getSelfStudyAndClassroom:
            return .admin
        }
    }

    public var urlPath: String {
        switch self {
        case .getSelfStudyDirector:
            return "/today"
        case .getAdminSelfStudyInfo:
            return "/admin"
        case .getSelfStudyAndClassroom:
            return "/main"
        }
    }

    public var method: Moya.Method {
        .get
    }

    public var task: Moya.Task {
        switch self {
        case let .getSelfStudyDirector(date):
            return .requestParameters(
                parameters: ["date": date],
                encoding: URLEncoding.queryString
            )
        case .getAdminSelfStudyInfo:
            return .requestPlain
        case .getSelfStudyAndClassroom:
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
