import XCTest
import Combine
import ComposableArchitecture
import SchoolMealDomainInterface
@testable import SchoolMealFeature

@MainActor
final class SchoolMealTests: XCTestCase {
    func testOnAppear_RequestsInitialDateAndStoresMeal() async {
        let selectedDate = fixedDate(year: 2026, month: 4, day: 16)
        let requestedMeal = sampleMeal(kcal: "700 kcal")
        let useCase = FetchSchoolMealUseCaseSpy { _ in
            Just(requestedMeal)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            useCase: useCase,
            initialState: state(selectedDate: selectedDate)
        )

        await store.send(.onAppear) {
            $0.isLoading = true
            $0.lastRequestedDate = selectedDate
        }
        await store.receive(
            {
                if case let .mealFetched(meal) = $0 {
                    return meal == requestedMeal
                }
                return false
            }
        ) {
            $0.isLoading = false
            $0.mealData = requestedMeal
        }

        XCTAssertEqual(useCase.requestedDates, [formattedDate(selectedDate)])
    }

    func testSelectedDateBinding_TriggersFetchForNewDate() async {
        let initialDate = fixedDate(year: 2026, month: 4, day: 16)
        let nextDate = fixedDate(year: 2026, month: 4, day: 17)
        let requestedMeal = sampleMeal(kcal: "720 kcal")
        let useCase = FetchSchoolMealUseCaseSpy { _ in
            Just(requestedMeal)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            useCase: useCase,
            initialState: state(selectedDate: initialDate, lastRequestedDate: initialDate)
        )

        await store.send(
            .binding(BindingAction<SchoolMealReducer.State>.allCasePaths.selectedDate.embed(nextDate))
        ) {
            $0.selectedDate = nextDate
            $0.isLoading = true
            $0.lastRequestedDate = nextDate
        }
        await store.receive(
            {
                if case let .mealFetched(meal) = $0 {
                    return meal == requestedMeal
                }
                return false
            }
        ) {
            $0.isLoading = false
            $0.mealData = requestedMeal
        }

        XCTAssertEqual(useCase.requestedDates, [formattedDate(nextDate)])
    }

    func testSelectedDateBinding_DoesNothingForSameDate() async {
        let selectedDate = fixedDate(year: 2026, month: 4, day: 16)
        let useCase = FetchSchoolMealUseCaseSpy()
        let store = makeStore(
            useCase: useCase,
            initialState: state(selectedDate: selectedDate, lastRequestedDate: selectedDate)
        )

        await store.send(
            .binding(BindingAction<SchoolMealReducer.State>.allCasePaths.selectedDate.embed(selectedDate))
        )

        XCTAssertTrue(useCase.requestedDates.isEmpty)
        XCTAssertFalse(store.state.isLoading)
    }

    func testLatestDateSelection_WinsOverPreviousInFlightRequest() async {
        let firstDate = fixedDate(year: 2026, month: 4, day: 16)
        let secondDate = fixedDate(year: 2026, month: 4, day: 17)
        let firstMeal = sampleMeal(kcal: "650 kcal")
        let secondMeal = sampleMeal(kcal: "710 kcal")

        var subjects: [String: PassthroughSubject<SchoolMealEntity, Error>] = [:]
        let useCase = FetchSchoolMealUseCaseSpy { date in
            let subject = subjects[date] ?? {
                let created = PassthroughSubject<SchoolMealEntity, Error>()
                subjects[date] = created
                return created
            }()
            return subject.eraseToAnyPublisher()
        }
        let store = makeStore(
            useCase: useCase,
            initialState: state(selectedDate: firstDate)
        )

        await store.send(
            .binding(BindingAction<SchoolMealReducer.State>.allCasePaths.selectedDate.embed(firstDate))
        ) {
            $0.selectedDate = firstDate
            $0.isLoading = true
            $0.lastRequestedDate = firstDate
        }

        await store.send(
            .binding(BindingAction<SchoolMealReducer.State>.allCasePaths.selectedDate.embed(secondDate))
        ) {
            $0.selectedDate = secondDate
            $0.isLoading = true
            $0.lastRequestedDate = secondDate
        }

        subjects[formattedDate(firstDate)]?.send(firstMeal)
        await Task.yield()
        XCTAssertNil(store.state.mealData)

        subjects[formattedDate(secondDate)]?.send(secondMeal)
        await store.receive(
            {
                if case let .mealFetched(meal) = $0 {
                    return meal == secondMeal
                }
                return false
            }
        ) {
            $0.isLoading = false
            $0.mealData = secondMeal
        }

        XCTAssertEqual(
            useCase.requestedDates,
            [formattedDate(firstDate), formattedDate(secondDate)]
        )

        subjects[formattedDate(secondDate)]?.send(completion: .finished)
        await store.finish()
    }

    func testOnAppear_FailureClearsLoadingAndStoresError() async {
        let selectedDate = fixedDate(year: 2026, month: 4, day: 16)
        let useCase = FetchSchoolMealUseCaseSpy { _ in
            Fail(error: TestError("load failed"))
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            useCase: useCase,
            initialState: state(selectedDate: selectedDate)
        )

        await store.send(.onAppear) {
            $0.isLoading = true
            $0.lastRequestedDate = selectedDate
        }
        await store.receive(
            {
                if case let .fetchFailed(message) = $0 {
                    return message == "load failed"
                }
                return false
            }
        ) {
            $0.isLoading = false
            $0.errorMessage = "load failed"
        }
    }

    private func makeStore(
        useCase: any FetchSchoolMealUseCaseProtocol = FetchSchoolMealUseCaseSpy(),
        initialState: SchoolMealReducer.State = .init()
    ) -> TestStore<SchoolMealReducer.State, SchoolMealReducer.Action> {
        TestStore(initialState: initialState) {
            SchoolMealReducer(fetchSchoolMealsUseCase: useCase)
        }
    }

    private func state(
        selectedDate: Date,
        mealData: SchoolMealEntity? = nil,
        isLoading: Bool = false,
        errorMessage: String? = nil,
        lastRequestedDate: Date? = nil
    ) -> SchoolMealReducer.State {
        var state = SchoolMealReducer.State()
        state.selectedDate = selectedDate
        state.mealData = mealData
        state.isLoading = isLoading
        state.errorMessage = errorMessage
        state.lastRequestedDate = lastRequestedDate
        return state
    }

    private func sampleMeal(kcal: String) -> SchoolMealEntity {
        SchoolMealEntity(
            meals: SchoolMealEntityElement(
                mealBundle: [
                    ("점심", MealEntityElement(menu: ["밥", "국"], kcal: kcal))
                ]
            )
        )
    }

    private func fixedDate(year: Int, month: Int, day: Int) -> Date {
        var components = DateComponents()
        components.calendar = Calendar(identifier: .gregorian)
        components.timeZone = TimeZone(secondsFromGMT: 0)
        components.year = year
        components.month = month
        components.day = day
        components.hour = 12
        return components.date!
    }

    private func formattedDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}

private final class FetchSchoolMealUseCaseSpy: FetchSchoolMealUseCaseProtocol {
    private let executeHandler: (String) -> AnyPublisher<SchoolMealEntity, Error>
    private(set) var requestedDates: [String] = []

    init(
        executeHandler: @escaping (String) -> AnyPublisher<SchoolMealEntity, Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(date: String) -> AnyPublisher<SchoolMealEntity, Error> {
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
