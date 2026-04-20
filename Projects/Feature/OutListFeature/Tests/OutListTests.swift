import Combine
import ComposableArchitecture
import OutListDomainInterface
import XCTest
@testable import OutListFeature

@MainActor
final class OutListTests: XCTestCase {
    func testOnAppear_LoadsDefaultOutingListOnlyOnce() async {
        let items = sampleOutListItems()
        let outListUseCase = GetOutListUseCaseSpy { _ in
            Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeOutListStore(
            outListUseCase: outListUseCase,
            returnStudentsUseCase: ReturnStudentsUseCaseSpy(),
            earlyReturnUseCase: GetEarlyReturnUseCaseSpy()
        )

        await store.send(.onAppear) {
            $0.hasAppeared = true
            $0.isLoading = true
        }
        await store.receive(
            {
                if case let .outListResponse(.success(receivedItems)) = $0 {
                    return receivedItems == items
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.studentItems = items
            }
        )

        await store.send(.onAppear)

        XCTAssertEqual(outListUseCase.requestedFloors, [5])
    }

    func testFloorChanged_WhenOuting_LoadsOutListAndClearsSelection() async {
        let items = sampleOutListItems()
        let outListUseCase = GetOutListUseCaseSpy { _ in
            Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeOutListStore(
            outListUseCase: outListUseCase,
            returnStudentsUseCase: ReturnStudentsUseCaseSpy(),
            earlyReturnUseCase: GetEarlyReturnUseCaseSpy(),
            initialState: makeOutListState(selectedStudents: ["student-1"], errorMessage: "stale")
        )

        await store.send(.floorChanged(3)) {
            $0.currentFloor = 3
            $0.isLoading = true
            $0.selectedStudents = []
            $0.errorMessage = nil
        }
        await store.receive(
            {
                if case let .outListResponse(.success(receivedItems)) = $0 {
                    return receivedItems == items
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.studentItems = items
            }
        )

        XCTAssertEqual(outListUseCase.requestedFloors, [3])
    }

    func testFloorChanged_WhenEarlyReturn_LoadsEarlyReturnAndClearsSelection() async {
        let items = sampleEarlyReturnItems()
        let earlyReturnUseCase = GetEarlyReturnUseCaseSpy { _, _ in
            Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeOutListStore(
            outListUseCase: GetOutListUseCaseSpy(),
            returnStudentsUseCase: ReturnStudentsUseCaseSpy(),
            earlyReturnUseCase: earlyReturnUseCase,
            initialState: makeOutListState(
                currentType: .earlyReturn,
                selectedStudents: ["student-1"],
                errorMessage: "stale"
            )
        )

        await store.send(.floorChanged(2)) {
            $0.currentFloor = 2
            $0.isLoading = true
            $0.selectedStudents = []
            $0.errorMessage = nil
        }
        await store.receive(
            {
                if case let .earlyReturnResponse(.success(receivedItems)) = $0 {
                    return receivedItems == items
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.earlyReturnItems = items
            }
        )

        XCTAssertEqual(earlyReturnUseCase.requestedArguments.count, 1)
        XCTAssertEqual(earlyReturnUseCase.requestedArguments.first?.floor, 2)
        XCTAssertEqual(earlyReturnUseCase.requestedArguments.first?.status, "OK")
    }

    func testFetchByType_ToEarlyReturn_LoadsEarlyReturnAndClearsSelection() async {
        let items = sampleEarlyReturnItems()
        let earlyReturnUseCase = GetEarlyReturnUseCaseSpy { _, _ in
            Just(items)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeOutListStore(
            outListUseCase: GetOutListUseCaseSpy(),
            returnStudentsUseCase: ReturnStudentsUseCaseSpy(),
            earlyReturnUseCase: earlyReturnUseCase,
            initialState: makeOutListState(
                currentFloor: 4,
                selectedStudents: ["student-1"],
                errorMessage: "stale"
            )
        )

        await store.send(.fetchByType(type: .earlyReturn)) {
            $0.currentType = .earlyReturn
            $0.isLoading = true
            $0.selectedStudents = []
            $0.errorMessage = nil
        }
        await store.receive(
            {
                if case let .earlyReturnResponse(.success(receivedItems)) = $0 {
                    return receivedItems == items
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.earlyReturnItems = items
            }
        )

        XCTAssertEqual(earlyReturnUseCase.requestedArguments.count, 1)
        XCTAssertEqual(earlyReturnUseCase.requestedArguments.first?.floor, 4)
        XCTAssertEqual(earlyReturnUseCase.requestedArguments.first?.status, "OK")
    }

    func testReturnStudentsSuccess_ShowsAlertClearsSelectionAndReloadsCurrentFloor() async {
        let reloadedItems = sampleOutListItems()
        let outListUseCase = GetOutListUseCaseSpy { _ in
            Just(reloadedItems)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let returnStudentsUseCase = ReturnStudentsUseCaseSpy { _ in
            Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeOutListStore(
            outListUseCase: outListUseCase,
            returnStudentsUseCase: returnStudentsUseCase,
            earlyReturnUseCase: GetEarlyReturnUseCaseSpy(),
            initialState: makeOutListState(currentFloor: 4, selectedStudents: ["student-1", "student-2"])
        )

        await store.send(.returnStudents)
        await store.receive(
            {
                if case .returnStudentsResponse(.success(())) = $0 {
                    return true
                }
                return false
            },
            assert: {
                $0.selectedStudents = []
                $0.errorMessage = nil
                $0.showAlert = true
                $0.alertSuccessType = .success
                $0.alertMessage = "복귀가 완료되었습니다!"
            }
        )
        await store.receive(
            {
                if case let .outListResponse(.success(receivedItems)) = $0 {
                    return receivedItems == reloadedItems
                }
                return false
            },
            assert: {
                $0.studentItems = reloadedItems
            }
        )

        XCTAssertEqual(Set(returnStudentsUseCase.requestedIds.first ?? []), ["student-1", "student-2"])
        XCTAssertEqual(outListUseCase.requestedFloors, [4])
    }

    func testReturnStudentsFailure_ShowsFailureAlertWithoutReload() async {
        let outListUseCase = GetOutListUseCaseSpy()
        let returnStudentsUseCase = ReturnStudentsUseCaseSpy { _ in
            Fail(error: TestError("return failed"))
                .eraseToAnyPublisher()
        }
        let store = makeOutListStore(
            outListUseCase: outListUseCase,
            returnStudentsUseCase: returnStudentsUseCase,
            earlyReturnUseCase: GetEarlyReturnUseCaseSpy(),
            initialState: makeOutListState(selectedStudents: ["student-1"])
        )

        await store.send(.returnStudents)
        await store.receive(
            {
                if case let .returnStudentsResponse(.failure(error)) = $0 {
                    return error.localizedDescription == "return failed"
                }
                return false
            },
            assert: {
                $0.showAlert = true
                $0.alertSuccessType = .fail
                $0.alertMessage = "복귀를 실패하였습니다"
            }
        )

        XCTAssertEqual(returnStudentsUseCase.requestedIds, [["student-1"]])
        XCTAssertTrue(outListUseCase.requestedFloors.isEmpty)
    }

    func testOutListFailure_StoresErrorAndKeepsExistingItems() async {
        let existingItems = sampleOutListItems()
        let store = makeOutListStore(
            outListUseCase: GetOutListUseCaseSpy { _ in
                Fail(error: TestError("load failed"))
                    .eraseToAnyPublisher()
            },
            returnStudentsUseCase: ReturnStudentsUseCaseSpy(),
            earlyReturnUseCase: GetEarlyReturnUseCaseSpy(),
            initialState: makeOutListState(studentItems: existingItems)
        )

        await store.send(.floorChanged(2)) {
            $0.currentFloor = 2
            $0.isLoading = true
            $0.selectedStudents = []
        }
        await store.receive(
            {
                if case let .outListResponse(.failure(error)) = $0 {
                    return error.localizedDescription == "load failed"
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.errorMessage = "load failed"
            }
        )

        XCTAssertEqual(store.state.studentItems, existingItems)
    }
}
