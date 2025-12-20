import Foundation
import Combine

public protocol GetApplicationsByFloorUseCaseProtocol {
    func execute(floor: Int) -> AnyPublisher<[ClassroomMoveEntity], Error>
}
