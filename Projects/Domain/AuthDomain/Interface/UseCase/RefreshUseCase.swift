import Combine

public protocol RefreshTokenUseCase {
    func execute() -> AnyPublisher<Void, Error>
}
