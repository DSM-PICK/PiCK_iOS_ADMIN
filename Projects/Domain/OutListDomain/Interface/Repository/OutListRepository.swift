import Combine

public protocol OutListRepository {
    func getOutList(floor: Int) -> AnyPublisher<[OutListResponseDTO], Error>
}
