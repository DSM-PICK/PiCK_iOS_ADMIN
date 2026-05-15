import XCTest
import Combine
import ComposableArchitecture
import ClassroomMoveListDomainInterface
@testable import ClassroomMoveListFeature

@MainActor
final class ClassroomMoveListFeatureTests: XCTestCase {
    func testOnAppear_FetchesSelectedFloor() async {
        let items = sampleItems()
        let floorUseCase = GetClassroomMoveByFloorUseCaseSpy { _ in
            Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            floorUseCase: floorUseCase,
            classroomUseCase: GetClassroomMoveByClassroomUseCaseSpy()
        )

        await store.send(.onAppear) {
            $0.isLoading = true
        }
        await store.receive(
            {
                if case let .fetchResponse(.success(students)) = $0 {
                    return students == items
                }
                return false
            },
            assert: {
            $0.isLoading = false
            $0.studentItems = items
            }
        )

        XCTAssertEqual(floorUseCase.requestedFloors, [2])
    }

    func testCurrentTypeBindingToClassroom_ResetsItemsAndFetchesWholeFloor() async {
        let items = sampleItems()
        let floorUseCase = GetClassroomMoveByFloorUseCaseSpy { _ in
            Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            floorUseCase: floorUseCase,
            classroomUseCase: GetClassroomMoveByClassroomUseCaseSpy(),
            initialState: state(studentItems: items)
        )

        await store.send(
            .binding(BindingAction<ClassroomMoveListReducer.State>.allCasePaths.currentType.embed(.classroom))
        ) {
            $0.currentType = .classroom
            $0.studentItems = []
            $0.isLoading = true
            $0.errorMessage = nil
        }
        await store.receive(
            {
                if case let .fetchResponse(.success(students)) = $0 {
                    return students == items
                }
                return false
            },
            assert: {
            $0.isLoading = false
            $0.studentItems = items
            }
        )

        XCTAssertEqual(floorUseCase.requestedFloors, [5])
    }

    func testCurrentTypeBindingToFloor_FetchesSelectedFloor() async {
        let items = sampleItems()
        let floorUseCase = GetClassroomMoveByFloorUseCaseSpy { _ in
            Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            floorUseCase: floorUseCase,
            classroomUseCase: GetClassroomMoveByClassroomUseCaseSpy(),
            initialState: state(
                currentType: .classroom,
                selectedFloor: 4,
                studentItems: items
            )
        )

        await store.send(
            .binding(BindingAction<ClassroomMoveListReducer.State>.allCasePaths.currentType.embed(.floor))
        ) {
            $0.currentType = .floor
            $0.studentItems = []
            $0.isLoading = true
            $0.errorMessage = nil
        }
        await store.receive(
            {
                if case let .fetchResponse(.success(students)) = $0 {
                    return students == items
                }
                return false
            },
            assert: {
            $0.isLoading = false
            $0.studentItems = items
            }
        )

        XCTAssertEqual(floorUseCase.requestedFloors, [4])
    }

    func testFetchFloor_UpdatesSelectionAndStoresResult() async {
        let items = sampleItems()
        let floorUseCase = GetClassroomMoveByFloorUseCaseSpy { _ in
            Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            floorUseCase: floorUseCase,
            classroomUseCase: GetClassroomMoveByClassroomUseCaseSpy()
        )

        await store.send(.fetchFloor(4)) {
            $0.isLoading = true
            $0.errorMessage = nil
            $0.selectedFloor = 4
        }
        await store.receive(
            {
                if case let .fetchResponse(.success(students)) = $0 {
                    return students == items
                }
                return false
            },
            assert: {
            $0.isLoading = false
            $0.studentItems = items
            }
        )

        XCTAssertEqual(floorUseCase.requestedFloors, [4])
    }

    func testFetchClassroom_UsesClassroomUseCaseWhenSpecificClassSelected() async {
        let items = sampleItems()
        let classroomUseCase = GetClassroomMoveByClassroomUseCaseSpy { _, _ in
            Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            floorUseCase: GetClassroomMoveByFloorUseCaseSpy(),
            classroomUseCase: classroomUseCase
        )

        await store.send(.fetchClassroom(grade: 2, classNum: 3)) {
            $0.isLoading = true
            $0.errorMessage = nil
            $0.selectedGrade = 2
            $0.selectedClassNum = 3
        }
        await store.receive(
            {
                if case let .fetchResponse(.success(students)) = $0 {
                    return students == items
                }
                return false
            },
            assert: {
            $0.isLoading = false
            $0.studentItems = items
            }
        )

        XCTAssertEqual(classroomUseCase.requestedClassrooms.count, 1)
        XCTAssertEqual(classroomUseCase.requestedClassrooms.first?.0, 2)
        XCTAssertEqual(classroomUseCase.requestedClassrooms.first?.1, 3)
    }

    func testFetchClassroom_FallsBackToFloorFiveWhenAllSelected() async {
        let items = sampleItems()
        let floorUseCase = GetClassroomMoveByFloorUseCaseSpy { _ in
            Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let classroomUseCase = GetClassroomMoveByClassroomUseCaseSpy()
        let store = makeStore(
            floorUseCase: floorUseCase,
            classroomUseCase: classroomUseCase
        )

        await store.send(.fetchClassroom(grade: 5, classNum: 5)) {
            $0.isLoading = true
            $0.errorMessage = nil
            $0.selectedGrade = 5
            $0.selectedClassNum = 5
        }
        await store.receive(
            {
                if case let .fetchResponse(.success(students)) = $0 {
                    return students == items
                }
                return false
            },
            assert: {
            $0.isLoading = false
            $0.studentItems = items
            }
        )

        XCTAssertEqual(floorUseCase.requestedFloors, [5])
        XCTAssertTrue(classroomUseCase.requestedClassrooms.isEmpty)
    }

    func testFetchFailure_ClearsItemsAndStoresError() async {
        let floorUseCase = GetClassroomMoveByFloorUseCaseSpy { _ in
            Fail(error: TestError("load failed"))
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            floorUseCase: floorUseCase,
            classroomUseCase: GetClassroomMoveByClassroomUseCaseSpy(),
            initialState: state(studentItems: sampleItems())
        )

        await store.send(.fetchFloor(3)) {
            $0.isLoading = true
            $0.errorMessage = nil
            $0.selectedFloor = 3
        }
        await store.receive(
            {
                if case let .fetchResponse(.failure(error)) = $0 {
                    return error.localizedDescription == "load failed"
                }
                return false
            },
            assert: {
            $0.isLoading = false
            $0.errorMessage = "load failed"
            $0.studentItems = []
            }
        )
    }
}

private extension ClassroomMoveListFeatureTests {
    func makeStore(
        floorUseCase: any GetClassroomMoveByFloorUseCase,
        classroomUseCase: any GetClassroomMoveByClassroomUseCase,
        initialState: ClassroomMoveListReducer.State = .init()
    ) -> TestStore<ClassroomMoveListReducer.State, ClassroomMoveListReducer.Action> {
        TestStore(initialState: initialState) {
            ClassroomMoveListReducer(
                getClassroomMoveByFloorUseCase: floorUseCase,
                getClassroomMoveByClassroomUseCase: classroomUseCase
            )
        }
    }

    func state(
        currentType: ClassroomMoveListReducer.ClassroomMoveListType = .floor,
        selectedFloor: Int = 2,
        selectedGrade: Int = 5,
        selectedClassNum: Int = 5,
        studentItems: [ClassroomMoveListEntity] = [],
        isLoading: Bool = false,
        errorMessage: String? = nil
    ) -> ClassroomMoveListReducer.State {
        var state = ClassroomMoveListReducer.State()
        state.currentType = currentType
        state.selectedFloor = selectedFloor
        state.selectedGrade = selectedGrade
        state.selectedClassNum = selectedClassNum
        state.studentItems = studentItems
        state.isLoading = isLoading
        state.errorMessage = errorMessage
        return state
    }

    func sampleItems() -> [ClassroomMoveListEntity] {
        [
            .init(
                userId: "1",
                userName: "김철수",
                classroomName: "물리실",
                move: "이동",
                grade: 2,
                classNum: 3,
                num: 7,
                start: 1,
                end: 2
            )
        ]
    }
}

private final class GetClassroomMoveByFloorUseCaseSpy: GetClassroomMoveByFloorUseCase {
    private let executeHandler: (Int) -> AnyPublisher<[ClassroomMoveListEntity], Error>
    private(set) var requestedFloors: [Int] = []

    init(
        executeHandler: @escaping (Int) -> AnyPublisher<[ClassroomMoveListEntity], Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(floor: Int) -> AnyPublisher<[ClassroomMoveListEntity], Error> {
        requestedFloors.append(floor)
        return executeHandler(floor)
    }
}

private final class GetClassroomMoveByClassroomUseCaseSpy: GetClassroomMoveByClassroomUseCase {
    private let executeHandler: (Int, Int) -> AnyPublisher<[ClassroomMoveListEntity], Error>
    private(set) var requestedClassrooms: [(Int, Int)] = []

    init(
        executeHandler: @escaping (Int, Int) -> AnyPublisher<[ClassroomMoveListEntity], Error> = { _, _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(grade: Int, classNum: Int) -> AnyPublisher<[ClassroomMoveListEntity], Error> {
        requestedClassrooms.append((grade, classNum))
        return executeHandler(grade, classNum)
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
