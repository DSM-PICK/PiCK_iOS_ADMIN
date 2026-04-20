import AcceptDomainInterface
import Combine
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import XCTest
@testable import AcceptFeature

@MainActor
final class AcceptFeatureTests: XCTestCase {
    func testFetchApplicationsByFloor_LoadsMovesAndClearsSelection() async {
        let moves = [sampleClassroomMove(id: "move-1")]
        let floorUseCase = GetApplicationsByFloorUseCaseSpy { floor in
            Just(moves)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            getApplicationsByFloorUseCase: floorUseCase,
            initialState: makeState(
                studentItems: [.application(sampleApplication(id: "application-1"))],
                selectedItemIds: ["application-1"]
            )
        )

        await store.send(.fetchApplicationsByFloor(floor: 4)) {
            $0.studentItems = []
            $0.selectedItemIds = []
            $0.isLoading = true
            $0.currentFloor = 4
            $0.currentType = .classroomMove
        }
        await store.receive(
            {
                if case let .classroomMovesResponse(.success(receivedMoves)) = $0 {
                    return receivedMoves == moves
                }
                return false
            },
            assert: {
                $0.studentItems = moves.map { .classroomMove($0) }
                $0.isLoading = false
            }
        )

        XCTAssertEqual(floorUseCase.requestedFloors, [4])
    }

    func testApproveSelectedApplications_UsesOutgoingUseCaseAndRemovesApprovedItems() async {
        let selectedApplication = sampleApplication(id: "application-1")
        let remainingApplication = sampleApplication(id: "application-2")
        let updateUseCase = UpdateApplicationStatusUseCaseSpy { _, _ in
            Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            updateApplicationStatusUseCase: updateUseCase,
            initialState: makeState(
                studentItems: [.application(selectedApplication), .application(remainingApplication)],
                selectedItemIds: [selectedApplication.id],
                currentType: .outgoing,
                alertSuccessType: .fail
            )
        )

        await store.send(.approveSelectedApplications) {
            $0.isLoading = true
        }
        await store.receive(
            {
                if case let .updateStatusResponse(.success(message)) = $0 {
                    return message == "1명의 외출 신청 수락이 완료되었습니다!"
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.studentItems = [.application(remainingApplication)]
                $0.selectedItemIds = []
                $0.alertSuccessType = .success
                $0.alertMessage = "1명의 외출 신청 수락이 완료되었습니다!"
                $0.showAlert = true
            }
        )

        XCTAssertEqual(updateUseCase.requestedArguments.map { $0.status }, ["OK"])
        XCTAssertEqual(updateUseCase.requestedArguments.map { $0.idList }, [[selectedApplication.id]])
    }

    func testRejectSelectedApplications_UsesEarlyReturnUseCaseAndRemovesRejectedItems() async {
        let selectedReturn = sampleEarlyReturn(id: "early-return-1")
        let remainingReturn = sampleEarlyReturn(id: "early-return-2")
        let updateUseCase = UpdateEarlyReturnStatusUseCaseSpy { _, _ in
            Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            updateEarlyReturnStatusUseCase: updateUseCase,
            initialState: makeState(
                studentItems: [.earlyReturn(selectedReturn), .earlyReturn(remainingReturn)],
                selectedItemIds: [selectedReturn.id],
                currentType: .earlyReturn
            )
        )

        await store.send(.rejectSelectedApplications) {
            $0.isLoading = true
        }
        await store.receive(
            {
                if case let .updateStatusResponse(.success(message)) = $0 {
                    return message == "1명의 조기 귀가 거절이 완료되었습니다!"
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.studentItems = [.earlyReturn(remainingReturn)]
                $0.selectedItemIds = []
                $0.alertSuccessType = .success
                $0.alertMessage = "1명의 조기 귀가 거절이 완료되었습니다!"
                $0.showAlert = true
            }
        )

        XCTAssertEqual(updateUseCase.requestedArguments.map { $0.status }, ["NO"])
        XCTAssertEqual(updateUseCase.requestedArguments.map { $0.idList }, [[selectedReturn.id]])
    }
}

private extension AcceptFeatureTests {
    func makeStore(
        getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol = GetAllApplicationsUseCaseSpy(),
        getApplicationsByFloorUseCase: any GetApplicationsByFloorUseCaseProtocol = GetApplicationsByFloorUseCaseSpy(),
        getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol = GetClassroomMovesUseCaseSpy(),
        getEarlyReturnByGradeUseCase: any GetEarlyReturnByGradeUseCaseProtocol = GetEarlyReturnByGradeUseCaseSpy(),
        updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol = UpdateApplicationStatusUseCaseSpy(),
        updateClassroomMoveStatusUseCase: any UpdateClassroomMoveStatusUseCaseProtocol = UpdateClassroomMoveStatusUseCaseSpy(),
        updateEarlyReturnStatusUseCase: any UpdateEarlyReturnStatusUseCaseProtocol = UpdateEarlyReturnStatusUseCaseSpy(),
        initialState: AcceptReducer.State = .init()
    ) -> TestStore<AcceptReducer.State, AcceptReducer.Action> {
        TestStore(initialState: initialState) {
            AcceptReducer(
                getAllApplicationsUseCase: getAllApplicationsUseCase,
                getApplicationsByFloorUseCase: getApplicationsByFloorUseCase,
                getClassroomMovesUseCase: getClassroomMovesUseCase,
                getEarlyReturnByGradeUseCase: getEarlyReturnByGradeUseCase,
                updateApplicationStatusUseCase: updateApplicationStatusUseCase,
                updateClassroomMoveStatusUseCase: updateClassroomMoveStatusUseCase,
                updateEarlyReturnStatusUseCase: updateEarlyReturnStatusUseCase
            )
        }
    }

    func makeState(
        studentItems: [AcceptReducer.StudentItem] = [],
        selectedItemIds: Set<String> = [],
        isLoading: Bool = false,
        currentGrade: Int = 5,
        currentClassNum: Int = 5,
        currentFloor: Int = 3,
        currentType: ApplicationType = .outgoing,
        showAlert: Bool = false,
        alertSuccessType: SuccessType = .success,
        alertMessage: String = ""
    ) -> AcceptReducer.State {
        var state = AcceptReducer.State()
        state.studentItems = studentItems
        state.selectedItemIds = selectedItemIds
        state.isLoading = isLoading
        state.currentGrade = currentGrade
        state.currentClassNum = currentClassNum
        state.currentFloor = currentFloor
        state.currentType = currentType
        state.showAlert = showAlert
        state.alertSuccessType = alertSuccessType
        state.alertMessage = alertMessage
        return state
    }

    func sampleApplication(id: String) -> ApplicationEntity {
        ApplicationEntity(
            id: id,
            userId: "user-\(id)",
            userName: "홍길동",
            start: "09:00",
            end: "10:00",
            grade: 2,
            classNum: 3,
            num: 7,
            reason: "병원"
        )
    }

    func sampleClassroomMove(id: String) -> ClassroomMoveEntity {
        ClassroomMoveEntity(
            id: id,
            userId: "user-\(id)",
            userName: "김영희",
            classroomName: "과학실",
            move: "과학실",
            grade: 1,
            classNum: 2,
            num: 5,
            start: 2,
            end: 3
        )
    }

    func sampleEarlyReturn(id: String) -> EarlyReturnAcceptEntity {
        EarlyReturnAcceptEntity(
            id: id,
            userName: "박민수",
            start: "11:00",
            grade: 3,
            classNum: 1,
            num: 9,
            reason: "조퇴"
        )
    }
}

private final class GetAllApplicationsUseCaseSpy: GetAllApplicationsUseCaseProtocol {
    private let executeHandler: (Int, Int) -> AnyPublisher<[ApplicationEntity], Error>

    init(
        executeHandler: @escaping (Int, Int) -> AnyPublisher<[ApplicationEntity], Error> = { _, _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(grade: Int, classNum: Int) -> AnyPublisher<[ApplicationEntity], Error> {
        executeHandler(grade, classNum)
    }
}

private final class GetApplicationsByFloorUseCaseSpy: GetApplicationsByFloorUseCaseProtocol {
    private let executeHandler: (Int) -> AnyPublisher<[ClassroomMoveEntity], Error>
    private(set) var requestedFloors: [Int] = []

    init(
        executeHandler: @escaping (Int) -> AnyPublisher<[ClassroomMoveEntity], Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(floor: Int) -> AnyPublisher<[ClassroomMoveEntity], Error> {
        requestedFloors.append(floor)
        return executeHandler(floor)
    }
}

private final class GetClassroomMovesUseCaseSpy: GetClassroomMovesUseCaseProtocol {
    private let executeHandler: (Int, Int) -> AnyPublisher<[ClassroomMoveEntity], Error>

    init(
        executeHandler: @escaping (Int, Int) -> AnyPublisher<[ClassroomMoveEntity], Error> = { _, _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(grade: Int, classNum: Int) -> AnyPublisher<[ClassroomMoveEntity], Error> {
        executeHandler(grade, classNum)
    }
}

private final class GetEarlyReturnByGradeUseCaseSpy: GetEarlyReturnByGradeUseCaseProtocol {
    private let executeHandler: (Int, Int) -> AnyPublisher<[EarlyReturnAcceptEntity], Error>

    init(
        executeHandler: @escaping (Int, Int) -> AnyPublisher<[EarlyReturnAcceptEntity], Error> = { _, _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(grade: Int, classNum: Int) -> AnyPublisher<[EarlyReturnAcceptEntity], Error> {
        executeHandler(grade, classNum)
    }
}

private final class UpdateApplicationStatusUseCaseSpy: UpdateApplicationStatusUseCaseProtocol {
    private let executeHandler: (String, [String]) -> AnyPublisher<Void, Error>
    private(set) var requestedArguments: [(status: String, idList: [String])] = []

    init(
        executeHandler: @escaping (String, [String]) -> AnyPublisher<Void, Error> = { _, _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        requestedArguments.append((status: status, idList: idList))
        return executeHandler(status, idList)
    }
}

private final class UpdateClassroomMoveStatusUseCaseSpy: UpdateClassroomMoveStatusUseCaseProtocol {
    private let executeHandler: (String, [String]) -> AnyPublisher<Void, Error>

    init(
        executeHandler: @escaping (String, [String]) -> AnyPublisher<Void, Error> = { _, _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        executeHandler(status, idList)
    }
}

private final class UpdateEarlyReturnStatusUseCaseSpy: UpdateEarlyReturnStatusUseCaseProtocol {
    private let executeHandler: (String, [String]) -> AnyPublisher<Void, Error>
    private(set) var requestedArguments: [(status: String, idList: [String])] = []

    init(
        executeHandler: @escaping (String, [String]) -> AnyPublisher<Void, Error> = { _, _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error> {
        requestedArguments.append((status: status, idList: idList))
        return executeHandler(status, idList)
    }
}
