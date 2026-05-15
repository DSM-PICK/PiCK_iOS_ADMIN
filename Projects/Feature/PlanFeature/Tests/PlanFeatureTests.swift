import XCTest
import Combine
import ComposableArchitecture
import PlanDomainInterface
@testable import PlanFeature

@MainActor
final class PlanFeatureTests: XCTestCase {
    func testSelectDate_UpdatesSelectedDateAndRequestsAcademicSchedule() async {
        let selectedDate = makeDate(year: 2026, month: 4, day: 20)
        let store = makeStore()

        await store.send(.selectDate(selectedDate)) {
            $0.selectedDate = selectedDate
        }
        await store.receive {
            if case .fetchAcademicSchedule(date: "2026-04-20") = $0 {
                return true
            }
            return false
        }
    }

    func testChangeMonth_UpdatesCurrentMonthAndRequestsMonthSchedule() async {
        let changedMonth = makeDate(year: 2026, month: 4, day: 1)
        let store = makeStore()

        await store.send(.changeMonth(changedMonth)) {
            $0.currentMonth = changedMonth
        }
        await store.receive {
            if case .fetchMonthAcademicSchedule(year: "2026", month: "April") = $0 {
                return true
            }
            return false
        }
    }

    func testFetchMonthAcademicSchedule_SuccessStoresMonthSchedule() async {
        let store = makeStore(
            monthUseCase: FetchMonthAcademicScheduleUseCaseSpy { year, month in
                XCTAssertEqual(year, "2026")
                XCTAssertEqual(month, "April")
                return Just(self.monthSchedule)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )

        await store.send(.fetchMonthAcademicSchedule(year: "2026", month: "April"))
        await store.receive(
            {
                if case let .monthAcademicScheduleResponse(.success(schedule)) = $0 {
                    return schedule == self.monthSchedule
                }
                return false
            },
            assert: {
                $0.monthAcademicSchedule = self.monthSchedule
            }
        )
    }

    func testFetchAcademicSchedule_SuccessStoresAcademicSchedule() async {
        let store = makeStore(
            academicUseCase: FetchAcademicScheduleUseCaseSpy { date in
                XCTAssertEqual(date, "2026-04-20")
                return Just(self.dailySchedule)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )

        await store.send(.fetchAcademicSchedule(date: "2026-04-20"))
        await store.receive(
            {
                if case let .academicScheduleResponse(.success(schedule)) = $0 {
                    return schedule == self.dailySchedule
                }
                return false
            },
            assert: {
                $0.academicSchedule = self.dailySchedule
            }
        )
    }

    func testFetchMonthAcademicSchedule_FailureClearsMonthSchedule() async {
        var initialState = PlanReducer.State()
        initialState.monthAcademicSchedule = monthSchedule
        let store = makeStore(
            monthUseCase: FetchMonthAcademicScheduleUseCaseSpy { _, _ in
                Fail(error: TestError("load failed"))
                    .eraseToAnyPublisher()
            },
            initialState: initialState
        )

        await store.send(.fetchMonthAcademicSchedule(year: "2026", month: "April"))
        await store.receive(
            {
                if case let .monthAcademicScheduleResponse(.failure(error)) = $0 {
                    return error.localizedDescription == "load failed"
                }
                return false
            },
            assert: {
                $0.monthAcademicSchedule = []
            }
        )
    }

    private func makeStore(
        monthUseCase: any FetchMonthAcademicScheduleUseCaseProtocol = FetchMonthAcademicScheduleUseCaseSpy(),
        academicUseCase: any FetchAcademicScheduleUseCaseProtocol = FetchAcademicScheduleUseCaseSpy(),
        initialState: PlanReducer.State = .init()
    ) -> TestStore<PlanReducer.State, PlanReducer.Action> {
        TestStore(initialState: initialState) {
            PlanReducer(
                fetchMonthAcademicScheduleUseCase: monthUseCase,
                fetchAcademicScheduleUseCase: academicUseCase
            )
        }
    }

    private var monthSchedule: AcademicScheduleEntity {
        [
            .init(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000001")!,
                eventName: "입학식",
                month: 4,
                day: 1,
                dayName: "화"
            )
        ]
    }

    private var dailySchedule: AcademicScheduleEntity {
        [
            .init(
                id: UUID(uuidString: "00000000-0000-0000-0000-000000000002")!,
                eventName: "중간고사",
                month: 4,
                day: 20,
                dayName: "월"
            )
        ]
    }

    private func makeDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.year = year
        components.month = month
        components.day = day
        return components.date!
    }
}

private final class FetchMonthAcademicScheduleUseCaseSpy: FetchMonthAcademicScheduleUseCaseProtocol {
    private let executeHandler: (String, String) -> AnyPublisher<AcademicScheduleEntity, Error>

    init(
        executeHandler: @escaping (String, String) -> AnyPublisher<AcademicScheduleEntity, Error> = { _, _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(year: String, month: String) -> AnyPublisher<AcademicScheduleEntity, Error> {
        executeHandler(year, month)
    }
}

private final class FetchAcademicScheduleUseCaseSpy: FetchAcademicScheduleUseCaseProtocol {
    private let executeHandler: (String) -> AnyPublisher<AcademicScheduleEntity, Error>

    init(
        executeHandler: @escaping (String) -> AnyPublisher<AcademicScheduleEntity, Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(date: String) -> AnyPublisher<AcademicScheduleEntity, Error> {
        executeHandler(date)
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
