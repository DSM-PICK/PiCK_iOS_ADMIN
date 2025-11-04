import Foundation
import Moya
import BaseDomain
import AuthDomainInterface

public enum EmailAPI {
    case emailSend(EmailSendRequestParams)
    case codeCheck(CodeCheckRequestParams)
}

extension EmailAPI: PiCKAPI {
    public typealias ErrorType = EmailError
    
    public var domain: PiCKDomain {
        return .mail
    }

    public var urlPath: String {
        switch self {
        case .emailSend:
            return "/send"
        case .codeCheck:
            return "/check"
        }
    }

    public var method: Moya.Method {
        switch self {
        case .emailSend:
            return .post
        case .codeCheck:
            return .post
        }
    }

    public var task: Moya.Task {
        switch self {
        case .emailSend(let params):
            return .requestJSONEncodable(params)
        case .codeCheck(let params):
            return .requestJSONEncodable(params)
        }
    }

    public var errorMap: [Int : AuthDomainInterface.EmailError]? {
        switch self {
        case .emailSend:
            return [
                400: .clientError,
                401: .clientError,
                404: .clientError,
                500: .serverError,
                503: .serverError
            ]
        case .codeCheck:
            return [
                400: .codeMismatch,
                401: .clientError,
                404: .clientError,
                500: .serverError,
                503: .serverError
            ]
        }
    }

    public var pickHeader: BaseDomain.TokenType {
        switch self {
        default:
            return .tokenIsEmpty
        }
    }
}
