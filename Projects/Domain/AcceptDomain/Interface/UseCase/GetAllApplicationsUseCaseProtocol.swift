import Foundation
import Combine

public protocol GetAllApplicationsUseCaseProtocol {
    func execute(grade: Int, classNum: Int) -> AnyPublisher<[ApplicationEntity], Error>
}
