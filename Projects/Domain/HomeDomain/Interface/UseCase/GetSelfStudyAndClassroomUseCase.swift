import Foundation
import Combine

public protocol GetSelfStudyAndClassroomUseCase {
    func execute() -> AnyPublisher<GetSelfStudyAndClassroomEntity, Error>
}
