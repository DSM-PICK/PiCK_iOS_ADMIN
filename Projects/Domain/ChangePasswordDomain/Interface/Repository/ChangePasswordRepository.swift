import Combine

public protocol ChangePasswordRepository {
    func changePassword(req: PasswordChangeRequestParams) -> AnyPublisher<Void, Error>
}
