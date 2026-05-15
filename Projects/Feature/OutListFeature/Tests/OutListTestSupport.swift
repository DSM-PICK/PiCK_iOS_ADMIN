import Combine
import ComposableArchitecture
import Foundation
import OutListDomainInterface
import PiCK_iOS_DesignSystem
@testable import OutListFeature

@MainActor
func makeOutListStore(
    outListUseCase: any GetOutListUseCase,
    returnStudentsUseCase: any ReturnStudentsUseCase,
    earlyReturnUseCase: any GetEarlyReturnUseCase,
    initialState: OutListReducer.State = .init()
) -> TestStore<OutListReducer.State, OutListReducer.Action> {
    TestStore(initialState: initialState) {
        OutListReducer(
            getOutListUseCase: outListUseCase,
            returnStudentsUseCase: returnStudentsUseCase,
            getEarlyReturnUseCase: earlyReturnUseCase
        )
    }
}

func makeOutListState(
    studentItems: [OutListEntity] = [],
    earlyReturnItems: [EarlyReturnEntity] = [],
    currentFloor: Int = 5,
    currentType: OutListReducer.OutListType = .outing,
    isLoading: Bool = false,
    selectedStudents: Set<String> = [],
    errorMessage: String? = nil,
    hasAppeared: Bool = false,
    showAlert: Bool = false,
    alertSuccessType: SuccessType = .success,
    alertMessage: String = ""
) -> OutListReducer.State {
    var state = OutListReducer.State()
    state.studentItems = studentItems
    state.earlyReturnItems = earlyReturnItems
    state.currentFloor = currentFloor
    state.currentType = currentType
    state.isLoading = isLoading
    state.selectedStudents = selectedStudents
    state.errorMessage = errorMessage
    state.hasAppeared = hasAppeared
    state.showAlert = showAlert
    state.alertSuccessType = alertSuccessType
    state.alertMessage = alertMessage
    return state
}

func sampleOutListItems() -> [OutListEntity] {
    [
        .init(
            id: "student-1",
            userId: "user-1",
            userName: "김철수",
            start: "09:00",
            end: "10:00",
            grade: 2,
            classNum: 3,
            num: 7,
            reason: "병원"
        )
    ]
}

func sampleEarlyReturnItems() -> [EarlyReturnEntity] {
    [
        .init(
            id: "early-1",
            userName: "이영희",
            start: "11:00",
            grade: 1,
            classNum: 2,
            num: 5,
            reason: "조퇴"
        )
    ]
}

final class GetOutListUseCaseSpy: GetOutListUseCase {
    private let executeHandler: (Int) -> AnyPublisher<[OutListEntity], Error>
    private(set) var requestedFloors: [Int] = []

    init(
        executeHandler: @escaping (Int) -> AnyPublisher<[OutListEntity], Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(floor: Int) -> AnyPublisher<[OutListEntity], Error> {
        requestedFloors.append(floor)
        return executeHandler(floor)
    }
}

final class ReturnStudentsUseCaseSpy: ReturnStudentsUseCase {
    private let executeHandler: ([String]) -> AnyPublisher<Void, Error>
    private(set) var requestedIds: [[String]] = []

    init(
        executeHandler: @escaping ([String]) -> AnyPublisher<Void, Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(ids: [String]) -> AnyPublisher<Void, Error> {
        requestedIds.append(ids)
        return executeHandler(ids)
    }
}

final class GetEarlyReturnUseCaseSpy: GetEarlyReturnUseCase {
    private let executeHandler: (Int, String) -> AnyPublisher<[EarlyReturnEntity], Error>
    private(set) var requestedArguments: [(floor: Int, status: String)] = []

    init(
        executeHandler: @escaping (Int, String) -> AnyPublisher<[EarlyReturnEntity], Error> = { _, _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(floor: Int, status: String) -> AnyPublisher<[EarlyReturnEntity], Error> {
        requestedArguments.append((floor: floor, status: status))
        return executeHandler(floor, status)
    }
}

struct TestError: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        message
    }
}
