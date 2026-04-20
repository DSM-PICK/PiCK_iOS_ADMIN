import Combine
import XCTest

@MainActor
final class OutListReducerTransientStateTests: XCTestCase {
    func testStudentTapped_TogglesSelection() async {
        let store = makeOutListStore(
            outListUseCase: GetOutListUseCaseSpy(),
            returnStudentsUseCase: ReturnStudentsUseCaseSpy(),
            earlyReturnUseCase: GetEarlyReturnUseCaseSpy()
        )

        await store.send(.studentTapped("student-1")) {
            $0.selectedStudents = ["student-1"]
        }
        await store.send(.studentTapped("student-1")) {
            $0.selectedStudents = []
        }
    }

    func testFetchByType_ToOuting_LoadsOutListAndClearsSelectionAndError() async {
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
            initialState: makeOutListState(
                currentFloor: 3,
                currentType: .earlyReturn,
                selectedStudents: ["student-1"],
                errorMessage: "stale"
            )
        )

        await store.send(.fetchByType(type: .outing)) {
            $0.currentType = .outing
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

    func testReturnStudents_WhenSelectionIsEmpty_DoesNotTriggerSideEffect() async {
        let outListUseCase = GetOutListUseCaseSpy()
        let returnStudentsUseCase = ReturnStudentsUseCaseSpy()
        let store = makeOutListStore(
            outListUseCase: outListUseCase,
            returnStudentsUseCase: returnStudentsUseCase,
            earlyReturnUseCase: GetEarlyReturnUseCaseSpy()
        )

        await store.send(.returnStudents)

        XCTAssertTrue(returnStudentsUseCase.requestedIds.isEmpty)
        XCTAssertTrue(outListUseCase.requestedFloors.isEmpty)
        XCTAssertEqual(store.state.selectedStudents, [])
    }

    func testEarlyReturnFailure_StoresErrorAndKeepsExistingItems() async {
        let existingItems = sampleEarlyReturnItems()
        let store = makeOutListStore(
            outListUseCase: GetOutListUseCaseSpy(),
            returnStudentsUseCase: ReturnStudentsUseCaseSpy(),
            earlyReturnUseCase: GetEarlyReturnUseCaseSpy { _, _ in
                Fail(error: TestError("early return failed"))
                    .eraseToAnyPublisher()
            },
            initialState: makeOutListState(
                earlyReturnItems: existingItems,
                currentType: .earlyReturn,
                errorMessage: "stale"
            )
        )

        await store.send(.floorChanged(4)) {
            $0.currentFloor = 4
            $0.isLoading = true
            $0.selectedStudents = []
            $0.errorMessage = nil
        }
        await store.receive(
            {
                if case let .earlyReturnResponse(.failure(error)) = $0 {
                    return error.localizedDescription == "early return failed"
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.errorMessage = "early return failed"
            }
        )

        XCTAssertEqual(store.state.earlyReturnItems, existingItems)
    }

    func testClearErrorAndDismissAlert_ResetTransientState() async {
        let store = makeOutListStore(
            outListUseCase: GetOutListUseCaseSpy(),
            returnStudentsUseCase: ReturnStudentsUseCaseSpy(),
            earlyReturnUseCase: GetEarlyReturnUseCaseSpy(),
            initialState: makeOutListState(
                errorMessage: "stale",
                showAlert: true,
                alertMessage: "복귀가 완료되었습니다!"
            )
        )

        await store.send(.clearError) {
            $0.errorMessage = nil
        }
        await store.send(.dismissAlert) {
            $0.showAlert = false
        }
    }
}
