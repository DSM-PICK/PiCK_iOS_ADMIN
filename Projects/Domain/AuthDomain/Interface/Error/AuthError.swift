import Foundation

public enum AuthError: Error {
    case idMismatch
    case passwordMismatch
    case clientError
    case serverError
}

extension AuthError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .idMismatch:
            return "올바른 아이디를 입력해주세요"
        case .passwordMismatch:
            return "올바른 비밀번호를 입력해주세요"
        case .clientError:
            return "가까운 PiCK 관계자에게 문의하세요"
        case .serverError:
            return "서버와 연결이 끊겼습니다"
        }
    }
}
