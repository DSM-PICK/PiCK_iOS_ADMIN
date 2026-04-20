import XCTest
import Combine
import ComposableArchitecture
import SelfStudyCheckDomainInterface
@testable import SelfStudyCheckFeature

@MainActor
final class SelfStudyCheckTests: XCTestCase {
    func testUpdateStudentStatus_MarksStateChangedUntilSaveSucceeds() async {
        let studentItem = SelfStudyCheckReducer.StudentItem(
            id: "student-1",
            grade: 1,
            classNum: 1,
            num: 1,
            userName: "홍길동",
            status: "출석"
        )
        var initialState = SelfStudyCheckReducer.State()
        initialState.studentItems = [studentItem]
        initialState.initialStudentItems = [studentItem]
        let store = makeStore(initialState: initialState)

        await store.send(.updateStudentStatus(id: "student-1", status: "외출")) {
            $0.studentItems[0] = SelfStudyCheckReducer.StudentItem(
                id: "student-1",
                grade: 1,
                classNum: 1,
                num: 1,
                userName: "홍길동",
                status: "외출"
            )
        }
        XCTAssertTrue(store.state.isChanged)

        await store.send(.saveAttendanceResponse(.success(()))) {
            $0.initialStudentItems = $0.studentItems
        }
        XCTAssertFalse(store.state.isChanged)
    }

    private func makeStore(
        initialState: SelfStudyCheckReducer.State = .init()
    ) -> TestStore<SelfStudyCheckReducer.State, SelfStudyCheckReducer.Action> {
        TestStore(initialState: initialState) {
            SelfStudyCheckReducer(
                getStudentAttendanceUseCase: GetStudentAttendanceUseCaseSpy(),
                saveAttendanceUseCase: SaveAttendanceUseCaseSpy()
            )
        }
    }
}

private final class GetStudentAttendanceUseCaseSpy: GetStudentAttendanceUseCase {
    func execute(grade: Int, classNum: Int, period: Int) -> AnyPublisher<[StudentAttendanceEntity], Error> {
        Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}

private final class SaveAttendanceUseCaseSpy: SaveAttendanceUseCase {
    func execute(period: Int, attendances: [AttendanceUpdateRequestDTO]) -> AnyPublisher<Void, Error> {
        Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }
}
