import Combine

public protocol SigninUseCase {
    func execute(req: SigninRequestParams) -> AnyPublisher<Void, Error>
}
