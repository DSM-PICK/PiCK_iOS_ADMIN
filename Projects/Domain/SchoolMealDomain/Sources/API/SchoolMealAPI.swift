import Foundation
import BaseDomain
import Moya

public enum SchoolMealAPI {
    case getSchoolMeal(date: String)
}

extension SchoolMealAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var domain: BaseDomain.PiCKDomain {
        return .meal
    }

    public var urlPath: String {
        switch self {
        case .getSchoolMeal:
            return "/date"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case let .getSchoolMeal(date):
            return .requestParameters(
                parameters:["date": date],
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
