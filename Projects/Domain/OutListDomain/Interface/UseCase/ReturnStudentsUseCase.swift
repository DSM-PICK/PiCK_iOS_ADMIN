import Foundation
import Combine

public protocol ReturnStudentsUseCase {
    func execute(ids: [String]) -> AnyPublisher<Void, Error>
}
