import Foundation
import BaseDomain
import Moya

public enum SelfStudyAPI {
    case getSelfStudyDirector(date: String)
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
        }
    }

    public var pickHeader: BaseDomain.TokenType {
        .accessToken
    }
    
    public var errorMap: [Int : ErrorType]? {
        return nil
    }
}
