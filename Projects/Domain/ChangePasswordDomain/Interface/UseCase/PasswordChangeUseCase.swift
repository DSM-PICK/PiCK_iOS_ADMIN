import Combine

public protocol PasswordChangeUseCase {
    func execute(req: PasswordChangeRequestParams) -> AnyPublisher<Void, Error>
}
