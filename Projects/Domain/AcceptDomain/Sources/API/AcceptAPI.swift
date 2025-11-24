import Foundation
import BaseDomain
import Moya

public enum AcceptAPI {
    case getApplicationsByGrade(grade: Int, classNum: Int)
    case updateApplicationStatus(status: String, idList: [String])
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
        case .updateApplicationStatus:
            return "/status"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .getApplicationsByGrade:
            return .get
        case .updateApplicationStatus:
            return .patch
        }
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
        case let .updateApplicationStatus(status, idList):
            return .requestJSONEncodable(
                UpdateStatusRequest(status: status, idList: idList)
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

struct UpdateStatusRequest: Encodable {
    let status: String
    let idList: [String]

    enum CodingKeys: String, CodingKey {
        case status
        case idList = "id_list"
    }
}
