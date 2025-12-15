import Combine

public protocol SaveAttendanceUseCase {
    func execute(period: Int, attendances: [AttendanceUpdateRequestDTO]) -> AnyPublisher<Void, Error>
}
