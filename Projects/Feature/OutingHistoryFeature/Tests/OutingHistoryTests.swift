import XCTest
import Combine
import ComposableArchitecture
import OutingHistoryDomainInterface
@testable import OutingHistoryFeature

@MainActor
final class OutingHistoryTests: XCTestCase {
    func testSearchBinding_UpdatesState() async {
        let store = makeStore()

        await store.send(
            .binding(BindingAction<OutingHistoryReducer.State>.allCasePaths.searchText.embed("김철수"))
        ) {
            $0.searchText = "김철수"
        }
    }

    func testFilteredStudentItems_FiltersByNameAndStudentNumber() {
        var state = OutingHistoryReducer.State()
        state.studentItems = sampleItems
        state.searchText = "1101김"

        XCTAssertEqual(state.filteredStudentItems.map(\.id), ["1"])
    }

    func testOnAppear_SetsLoadingThenStoresLoadedItems() async {
        let store = makeStore(
            useCase: GetOutingHistoryUseCaseSpy {
                Just(self.sampleItems)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )

        await store.send(OutingHistoryReducer.Action.onAppear) {
            $0.isLoading = true
        }
        await store.receive(
            {
                if case .outingHistoryResponse(.success(let students)) = $0 {
                    return students == self.sampleItems
                }
                return false
            }
        ) {
            $0.isLoading = false
            $0.studentItems = self.sampleItems
        }
    }

    func testOnAppear_FailureClearsLoading() async {
        let store = makeStore(
            useCase: GetOutingHistoryUseCaseSpy {
                Fail(error: TestError("load failed"))
                    .eraseToAnyPublisher()
            }
        )

        await store.send(OutingHistoryReducer.Action.onAppear) {
            $0.isLoading = true
        }
        await store.receive(
            {
                if case let .outingHistoryResponse(.failure(error)) = $0 {
                    return error.localizedDescription == "load failed"
                }
                return false
            }
        ) {
            $0.isLoading = false
        }
    }

    private func makeStore(
        useCase: any GetOutingHistoryUseCase = GetOutingHistoryUseCaseSpy()
    ) -> TestStore<OutingHistoryReducer.State, OutingHistoryReducer.Action> {
        TestStore(initialState: OutingHistoryReducer.State()) {
            OutingHistoryReducer(getOutingHistoryUseCase: useCase)
        }
    }

    private var sampleItems: [OutingHistoryEntity] {
        [
            .init(id: "1", userName: "김철수", grade: 1, classNum: 1, num: 1, applicationCnt: 2, earlyReturnCnt: 0),
            .init(id: "2", userName: "이영희", grade: 2, classNum: 3, num: 4, applicationCnt: 1, earlyReturnCnt: 1)
        ]
    }
}

private final class GetOutingHistoryUseCaseSpy: GetOutingHistoryUseCase {
    private let executeHandler: () -> AnyPublisher<[OutingHistoryEntity], Error>

    init(
        executeHandler: @escaping () -> AnyPublisher<[OutingHistoryEntity], Error> = {
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute() -> AnyPublisher<[OutingHistoryEntity], Error> {
        executeHandler()
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
