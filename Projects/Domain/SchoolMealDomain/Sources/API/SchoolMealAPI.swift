import Foundation
import Moya

public enum SchoolMealAPI {
    case fetchSchoolMeal(date: String)
}

extension SchoolMealAPI: TargetType {
    public var baseURL: URL {
        return URL(string: "https://open.neis.go.kr/hub")!
    }

    public var path: String {
        switch self {
        case .fetchSchoolMeal:
            return "/mealServiceDietInfo"
        }
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        switch self {
        case .fetchSchoolMeal(let date):
            let neisDate = date.replacingOccurrences(of: "-", with: "")
            return .requestParameters(
                parameters: [
                    "KEY": "d7841b2039214f68b21eafc749ba196a",
                    "Type": "json",
                    "pIndex": 1,
                    "pSize": 100,
                    "ATPT_OFCDC_SC_CODE": "G10",
                    "SD_SCHUL_CODE": "7430310",
                    "MLSV_YMD": neisDate
                ],
                encoding: URLEncoding.queryString
            )
        }
    }

    public var headers: [String: String]? {
        return ["Content-Type": "application/json"]
    }

    public var validationType: ValidationType {
        return .successCodes
    }
}
