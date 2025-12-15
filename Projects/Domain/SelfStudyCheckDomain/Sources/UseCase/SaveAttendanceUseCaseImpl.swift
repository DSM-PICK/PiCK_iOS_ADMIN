import Combine
import SelfStudyCheckDomainInterface

public class SaveAttendanceUseCaseImpl: SaveAttendanceUseCase {
    private let repository: SelfStudyCheckRepository

    public init(repository: SelfStudyCheckRepository) {
        self.repository = repository
    }

    public func execute(period: Int, attendances: [AttendanceUpdateRequestDTO]) -> AnyPublisher<Void, Error> {
        repository.modifyAttendance(period: period, attendances: attendances)
    }
}
