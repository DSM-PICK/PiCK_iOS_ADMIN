import Foundation

public enum ChangePasswordError: Error {
    case badRequest
    case notFound
    case serverError
}

extension ChangePasswordError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .badRequest:
            return "잘못된 요청입니다"
        case .notFound:
            return "사용자를 찾을 수 없습니다"
        case .serverError:
            return "서버 오류가 발생했습니다"
        }
    }
}
