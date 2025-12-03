import Combine

public protocol GetOutListUseCase {
    func execute(floor: Int) -> AnyPublisher<[OutListResponseDTO], Error>
}
