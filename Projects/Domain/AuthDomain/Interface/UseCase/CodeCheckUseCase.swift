import Combine

public protocol CodeCheckUseCase {
    func execute(req: CodeCheckRequestParams) -> AnyPublisher<Bool, Error>
}
