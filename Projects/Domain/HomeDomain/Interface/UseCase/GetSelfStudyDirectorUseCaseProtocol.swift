import Foundation
import Combine

public protocol GetSelfStudyDirectorUseCaseProtocol {
    func execute(date: String) -> AnyPublisher<[SelfStudyDirectorEntity], Error>
}
