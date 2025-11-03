import Foundation
import BaseDomain
import Moya

public enum SelfStudyAPI {
    case getSelfStudyDirector(date: String)
    case getAdminSelfStudyInfo
}

extension SelfStudyAPI: PiCKAPI {
    public typealias ErrorType = Never

    public var domain: BaseDomain.PiCKDomain {
        .selfStudy
    }

    public var urlPath: String {
        switch self {
        case .getSelfStudyDirector:
            return "/today"
        case .getAdminSelfStudyInfo:
            return "/admin"
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
        }
    }

    public var pickHeader: BaseDomain.TokenType {
        .accessToken
    }
    
    public var errorMap: [Int : ErrorType]? {
        return nil
    }
}
