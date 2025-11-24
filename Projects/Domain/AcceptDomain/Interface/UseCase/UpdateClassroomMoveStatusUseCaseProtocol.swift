import Foundation
import Combine

public protocol UpdateClassroomMoveStatusUseCaseProtocol {
    func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error>
}
