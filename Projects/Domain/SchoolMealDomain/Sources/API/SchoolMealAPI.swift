import Foundation
import BaseDomain
import Moya

public enum SchoolMealAPI {
    case fetchSchoolMeal(date: String)
}

extension SchoolMealAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var domain: BaseDomain.PiCKDomain {
        return .meal
    }

    public var urlPath: String {
        switch self {
        case .fetchSchoolMeal:
            return "/date"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case let .fetchSchoolMeal(date):
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
