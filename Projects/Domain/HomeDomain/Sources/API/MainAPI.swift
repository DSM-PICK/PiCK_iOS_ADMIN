import Foundation
import BaseDomain
import Moya

public enum MainAPI {
    case getSelfStudyAndClassroom(selfStudyFloor: Int, grade: Int, classNum: Int)
}

extension MainAPI: PiCKAPI {
    public typealias ErrorType = PiCKError

    public var domain: BaseDomain.PiCKDomain {
        return .admin
    }

    public var urlPath: String {
        return "/main"
    }

    public var method: Moya.Method {
        return .get
    }

    public var task: Moya.Task {
        return .requestPlain
    }

    public var pickHeader: BaseDomain.TokenType {
        .accessToken
    }

    public var errorMap: [Int : BaseDomain.PiCKError]? {
        return nil
    }
}
