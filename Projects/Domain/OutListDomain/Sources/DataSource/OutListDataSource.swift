import Combine
import OutListDomainInterface

public protocol OutListDataSource {
    func getOutList(floor: Int) -> AnyPublisher<[OutListResponseDTO], Error>
}
