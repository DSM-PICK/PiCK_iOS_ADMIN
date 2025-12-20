import Foundation
import Combine

public protocol GetMyNameUseCaseProtocol {
    func execute() -> AnyPublisher<MyNameEntity, Error>
}
