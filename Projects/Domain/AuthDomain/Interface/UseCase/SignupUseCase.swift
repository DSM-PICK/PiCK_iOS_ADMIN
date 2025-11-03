import Combine

public protocol SignupUseCase {
    func execute(req: SignupRequestParams) -> AnyPublisher<Void, Error>
}
