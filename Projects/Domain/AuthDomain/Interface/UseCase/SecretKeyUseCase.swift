import Combine

public protocol SecretKeyUseCase {
    func execute(req: SecretKeyRequestParams) -> AnyPublisher<Bool, Error>
}
