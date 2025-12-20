import Foundation
import Combine

public protocol FetchAcademicScheduleUseCaseProtocol {
    func execute(date: String) -> AnyPublisher<AcademicScheduleEntity, Error>
}
