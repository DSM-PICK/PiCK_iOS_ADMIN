import Foundation
import BaseDomain
import Moya

enum SelfStudyAPI {
    case getSelfStudyDirector
}

extension SelfStudyAPI: PiCKAPI {
    typealias ErrorType = Never

    var domain: BaseDomain.PiCKDomain {
        .selfStudy
    }

    var urlPath: String {
        switch self {
        case .getSelfStudyDirector:
            return "/today"
        }
    }

    var method: Moya.Method {
        .get
    }

    var task: Moya.Task {
        .requestPlain
    }

    var pickHeader: BaseDomain.TokenType {
        .accessToken
    }
    
    var errorMap: [Int : ErrorType]? {
        return nil
    }
}
