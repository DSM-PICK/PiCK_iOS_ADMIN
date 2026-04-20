import XCTest
import Combine
import ComposableArchitecture
import CheckSelfStudyTeacherDomainInterface
@testable import CheckSelfStudyTeacherFeature

@MainActor
final class CheckSelfStudyTeacherFeatureTests: XCTestCase {
    func testOnAppear_RequestsSelectedDateAndStoresTeachers() async {
        let selectedDate = fixedDate(year: 2026, month: 4, day: 16)
        let teachers = sampleTeachers()
        let useCase = FetchSelfStudyTeacherUseCaseSpy { _ in
            Just(teachers)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            useCase: useCase,
            initialState: state(selectedDate: selectedDate)
        )

        await store.send(.onAppear) {
            $0.isLoading = true
        }
        await store.receive(
            {
                if case let .selfStudyTeacherResponse(.success(responseTeachers)) = $0 {
                    return responseTeachers == teachers
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.teachers = teachers
            }
        )

        XCTAssertEqual(useCase.requestedDates, [formattedDate(selectedDate)])
    }

    func testSelectedDateBinding_RequestsNewDateAndStoresTeachers() async {
        let initialDate = fixedDate(year: 2026, month: 4, day: 16)
        let nextDate = fixedDate(year: 2026, month: 4, day: 17)
        let teachers = sampleTeachers()
        let useCase = FetchSelfStudyTeacherUseCaseSpy { _ in
            Just(teachers)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            useCase: useCase,
            initialState: state(selectedDate: initialDate)
        )

        await store.send(
            .binding(BindingAction<CheckSelfStudyTeacherReducer.State>.allCasePaths.selectedDate.embed(nextDate))
        ) {
            $0.selectedDate = nextDate
            $0.isLoading = true
        }
        await store.receive(
            {
                if case let .selfStudyTeacherResponse(.success(responseTeachers)) = $0 {
                    return responseTeachers == teachers
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.teachers = teachers
            }
        )

        XCTAssertEqual(useCase.requestedDates, [formattedDate(nextDate)])
    }

    func testSelectedDateBinding_RequestsAgainForSameDate() async {
        let selectedDate = fixedDate(year: 2026, month: 4, day: 16)
        let teachers = sampleTeachers()
        let useCase = FetchSelfStudyTeacherUseCaseSpy { _ in
            Just(teachers)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            useCase: useCase,
            initialState: state(selectedDate: selectedDate)
        )

        await store.send(
            .binding(BindingAction<CheckSelfStudyTeacherReducer.State>.allCasePaths.selectedDate.embed(selectedDate))
        ) {
            $0.selectedDate = selectedDate
            $0.isLoading = true
        }
        await store.receive(
            {
                if case let .selfStudyTeacherResponse(.success(responseTeachers)) = $0 {
                    return responseTeachers == teachers
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.teachers = teachers
            }
        )

        XCTAssertEqual(useCase.requestedDates, [formattedDate(selectedDate)])
    }

    func testLatestDateSelection_WinsOverPreviousInFlightRequest() async {
        let firstDate = fixedDate(year: 2026, month: 4, day: 16)
        let secondDate = fixedDate(year: 2026, month: 4, day: 17)
        let firstTeachers = [
            SelfStudyTeacherEntity(floor: 2, teacherName: "첫번째")
        ]
        let secondTeachers = [
            SelfStudyTeacherEntity(floor: 3, teacherName: "두번째")
        ]

        var subjects: [String: PassthroughSubject<[SelfStudyTeacherEntity], Error>] = [:]
        let useCase = FetchSelfStudyTeacherUseCaseSpy { date in
            let subject = subjects[date] ?? {
                let created = PassthroughSubject<[SelfStudyTeacherEntity], Error>()
                subjects[date] = created
                return created
            }()
            return subject.eraseToAnyPublisher()
        }
        let store = makeStore(
            useCase: useCase,
            initialState: state(selectedDate: firstDate)
        )

        await requestTeachers(for: firstDate, store: store)
        await requestTeachers(for: secondDate, store: store)

        subjects[formattedDate(firstDate)]?.send(firstTeachers)
        await Task.yield()
        XCTAssertTrue(store.state.teachers.isEmpty)

        subjects[formattedDate(secondDate)]?.send(secondTeachers)
        await store.receive(
            {
                if case let .selfStudyTeacherResponse(.success(responseTeachers)) = $0 {
                    return responseTeachers == secondTeachers
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.teachers = secondTeachers
            }
        )

        XCTAssertEqual(
            useCase.requestedDates,
            [formattedDate(firstDate), formattedDate(secondDate)]
        )

        subjects[formattedDate(secondDate)]?.send(completion: .finished)
        await store.finish()
    }

    func testFetchFailure_StopsLoadingAndPreservesExistingTeachers() async {
        let selectedDate = fixedDate(year: 2026, month: 4, day: 16)
        let existingTeachers = sampleTeachers()
        let useCase = FetchSelfStudyTeacherUseCaseSpy { _ in
            Fail(error: TestError("load failed"))
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            useCase: useCase,
            initialState: state(selectedDate: selectedDate, teachers: existingTeachers)
        )

        await store.send(.onAppear) {
            $0.isLoading = true
        }
        await store.receive(
            {
                if case let .selfStudyTeacherResponse(.failure(error)) = $0 {
                    return error.localizedDescription == "load failed"
                }
                return false
            },
            assert: {
                $0.isLoading = false
            }
        )

        XCTAssertEqual(store.state.teachers, existingTeachers)
        XCTAssertEqual(useCase.requestedDates, [formattedDate(selectedDate)])
    }
}

private extension CheckSelfStudyTeacherFeatureTests {
    func makeStore(
        useCase: any FetchSelfStudyTeacherUseCaseProtocol,
        initialState: CheckSelfStudyTeacherReducer.State = .init()
    ) -> TestStore<CheckSelfStudyTeacherReducer.State, CheckSelfStudyTeacherReducer.Action> {
        TestStore(initialState: initialState) {
            CheckSelfStudyTeacherReducer(fetchSelfStudyTeacherUseCase: useCase)
        }
    }

    func state(
        selectedDate: Date,
        teachers: [SelfStudyTeacherEntity] = [],
        isLoading: Bool = false
    ) -> CheckSelfStudyTeacherReducer.State {
        var state = CheckSelfStudyTeacherReducer.State()
        state.selectedDate = selectedDate
        state.teachers = teachers
        state.isLoading = isLoading
        return state
    }

    func sampleTeachers() -> [SelfStudyTeacherEntity] {
        [
            .init(floor: 2, teacherName: "김자습"),
            .init(floor: 3, teacherName: "이감독")
        ]
    }

    func requestTeachers(
        for date: Date,
        store: TestStore<CheckSelfStudyTeacherReducer.State, CheckSelfStudyTeacherReducer.Action>
    ) async {
        await store.send(
            .binding(BindingAction<CheckSelfStudyTeacherReducer.State>.allCasePaths.selectedDate.embed(date))
        ) {
            $0.selectedDate = date
            $0.isLoading = true
        }
    }

    func fixedDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        return components.date!
    }

    func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

private final class FetchSelfStudyTeacherUseCaseSpy: FetchSelfStudyTeacherUseCaseProtocol {
    private let executeHandler: (String) -> AnyPublisher<[SelfStudyTeacherEntity], Error>
    private(set) var requestedDates: [String] = []

    init(
        executeHandler: @escaping (String) -> AnyPublisher<[SelfStudyTeacherEntity], Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(date: String) -> AnyPublisher<[SelfStudyTeacherEntity], Error> {
        requestedDates.append(date)
        return executeHandler(date)
    }
}

private struct TestError: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        message
    }
}
