import Foundation

public enum EmailError: Error {
    case codeMismatch
    case clientError
    case serverError
}

extension EmailError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .clientError:
            return "가까운 PiCK 관계자에게 문의하세요"
        case .serverError:
            return "서버와 연결이 끊겼습니다"
        case .codeMismatch:
            return "인증 코드가 일치하지 않습니다"
        }
    }
}
