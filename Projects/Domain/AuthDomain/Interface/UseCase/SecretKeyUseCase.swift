import Combine

public protocol SecretKeyUseCase {
    func execute(req: SecretKeyRequestParams) -> AnyPublisher<Void, Error>
}
