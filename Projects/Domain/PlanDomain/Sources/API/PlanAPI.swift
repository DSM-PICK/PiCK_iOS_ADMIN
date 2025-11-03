import Foundation
import BaseDomain
import Moya

public enum PlanAPI {
    case fetchAcademicScheduleByDate(date: String)
    case fetchMonthAcademicSchedule(year: String, month: String)
}

extension PlanAPI: PiCKAPI {
    public typealias ErrorType = Never

    public var domain: BaseDomain.PiCKDomain {
        .schedule
    }

    public var urlPath: String {
        switch self {
        case .fetchAcademicScheduleByDate:
            return "/date"
        case .fetchMonthAcademicSchedule:
            return "/month"
        }
    }

    public var method: Moya.Method {
        .get
    }

    public var task: Moya.Task {
        switch self {
        case let .fetchAcademicScheduleByDate(date):
            return .requestParameters(
                parameters: ["date": date],
                encoding: URLEncoding.queryString
            )
            
        case let .fetchMonthAcademicSchedule(year, month):
            return .requestParameters(
                parameters: [
                    "year": year,
                    "month": month
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
