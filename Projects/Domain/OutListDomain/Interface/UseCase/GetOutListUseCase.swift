import Foundation
import Combine

public protocol GetOutListUseCase {
    func execute(floor: Int) -> AnyPublisher<[OutListEntity], Error>
}
