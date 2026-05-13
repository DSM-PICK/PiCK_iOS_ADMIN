import XCTest
import Combine
import ComposableArchitecture
import SelfStudyCheckDomainInterface
@testable import SelfStudyCheckFeature

@MainActor
final class SelfStudyCheckTests: XCTestCase {
    func testFetchStudents_StoresStudentItemsAndClearsLoading() async {
        let entities = [
            StudentAttendanceEntity(
                id: "s1", userName: "홍길동",
                grade: 1, classNum: 1, num: 1,
                status: "ATTENDANCE", classroomName: "1-1"
            )
        ]
        let attendanceUseCase = GetStudentAttendanceUseCaseSpy { _, _, _ in
            Just(entities).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        let store = makeStore(attendanceUseCase: attendanceUseCase)
        let expectedItem = SelfStudyCheckReducer.StudentItem(
            id: "s1", grade: 1, classNum: 1, num: 1, userName: "홍길동", status: "출석"
        )

        await store.send(.fetchStudents) {
            $0.isLoading = true
        }
        await store.receive(
            { if case let .studentsResponse(.success(items)) = $0 { return items == [expectedItem] }; return false }
        ) {
            $0.isLoading = false
            $0.studentItems = [expectedItem]
            $0.initialStudentItems = [expectedItem]
        }
    }

    func testSelectPeriod_UpdatesSelectedPeriodAndRefetches() async {
        let attendanceUseCase = GetStudentAttendanceUseCaseSpy { _, _, _ in
            Just([StudentAttendanceEntity]()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        let store = makeStore(attendanceUseCase: attendanceUseCase)

        await store.send(.selectPeriod(.ninth)) {
            $0.selectedPeriod = .ninth
            $0.isLoading = true
        }
        await store.receive(
            { if case .studentsResponse(.success) = $0 { return true }; return false }
        ) {
            $0.isLoading = false
        }

        XCTAssertEqual(attendanceUseCase.receivedPeriods, [9])
    }

    func testSelectGradeAndClass_UpdatesFilterAndRefetches() async {
        let attendanceUseCase = GetStudentAttendanceUseCaseSpy { _, _, _ in
            Just([StudentAttendanceEntity]()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        let store = makeStore(attendanceUseCase: attendanceUseCase)

        await store.send(.selectGradeAndClass(grade: 2, classNum: 3)) {
            $0.selectedGrade = 2
            $0.selectedClass = 3
            $0.isLoading = true
        }
        await store.receive(
            { if case .studentsResponse(.success) = $0 { return true }; return false }
        ) {
            $0.isLoading = false
        }

        XCTAssertEqual(attendanceUseCase.receivedGrades, [2])
        XCTAssertEqual(attendanceUseCase.receivedClasses, [3])
    }

    func testSaveAttendance_SetsIsSavingThenClearsOnSuccess() async {
        let updatedItem = SelfStudyCheckReducer.StudentItem(
            id: "s1", grade: 1, classNum: 1, num: 1, userName: "홍길동", status: "외출"
        )
        var initialState = SelfStudyCheckReducer.State()
        initialState.studentItems = [updatedItem]
        initialState.initialStudentItems = [
            SelfStudyCheckReducer.StudentItem(
                id: "s1", grade: 1, classNum: 1, num: 1, userName: "홍길동", status: "출석"
            )
        ]
        let saveUseCase = SaveAttendanceUseCaseSpy { _, _ in
            Just(()).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
        let store = makeStore(saveUseCase: saveUseCase, initialState: initialState)

        await store.send(.saveAttendance) {
            $0.isSaving = true
        }
        await store.receive(
            { if case .saveAttendanceResponse(.success) = $0 { return true }; return false }
        ) {
            $0.isSaving = false
            $0.initialStudentItems = [updatedItem]
        }

        XCTAssertFalse(store.state.isChanged)
    }

    func testFetchStudents_FailureStopsLoading() async {
        let attendanceUseCase = GetStudentAttendanceUseCaseSpy { _, _, _ in
            Fail(error: TestError("fetch failed")).eraseToAnyPublisher()
        }
        let store = makeStore(attendanceUseCase: attendanceUseCase)

        await store.send(.fetchStudents) {
            $0.isLoading = true
        }
        await store.receive(
            { if case .studentsResponse(.failure) = $0 { return true }; return false }
        ) {
            $0.isLoading = false
        }

        XCTAssertTrue(store.state.studentItems.isEmpty)
    }

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
        attendanceUseCase: any GetStudentAttendanceUseCase = GetStudentAttendanceUseCaseSpy(),
        saveUseCase: any SaveAttendanceUseCase = SaveAttendanceUseCaseSpy(),
        initialState: SelfStudyCheckReducer.State = .init()
    ) -> TestStore<SelfStudyCheckReducer.State, SelfStudyCheckReducer.Action> {
        TestStore(initialState: initialState) {
            SelfStudyCheckReducer(
                getStudentAttendanceUseCase: attendanceUseCase,
                saveAttendanceUseCase: saveUseCase
            )
        }
    }
}

private final class GetStudentAttendanceUseCaseSpy: GetStudentAttendanceUseCase {
    private let handler: (Int, Int, Int) -> AnyPublisher<[StudentAttendanceEntity], Error>
    private(set) var receivedGrades: [Int] = []
    private(set) var receivedClasses: [Int] = []
    private(set) var receivedPeriods: [Int] = []

    init(
        handler: @escaping (Int, Int, Int) -> AnyPublisher<[StudentAttendanceEntity], Error> = { _, _, _ in
            Empty(completeImmediately: true).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    ) {
        self.handler = handler
    }

    func execute(grade: Int, classNum: Int, period: Int) -> AnyPublisher<[StudentAttendanceEntity], Error> {
        receivedGrades.append(grade)
        receivedClasses.append(classNum)
        receivedPeriods.append(period)
        return handler(grade, classNum, period)
    }
}

private final class SaveAttendanceUseCaseSpy: SaveAttendanceUseCase {
    private let handler: (Int, [AttendanceUpdateRequestDTO]) -> AnyPublisher<Void, Error>

    init(
        handler: @escaping (Int, [AttendanceUpdateRequestDTO]) -> AnyPublisher<Void, Error> = { _, _ in
            Empty(completeImmediately: true).setFailureType(to: Error.self).eraseToAnyPublisher()
        }
    ) {
        self.handler = handler
    }

    func execute(period: Int, attendances: [AttendanceUpdateRequestDTO]) -> AnyPublisher<Void, Error> {
        handler(period, attendances)
    }
}

private struct TestError: LocalizedError {
    let message: String
    init(_ message: String) { self.message = message }
    var errorDescription: String? { message }
}
