import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Foundation
import OutingHistoryDomainInterface

public struct OutingHistoryReducer: Reducer {
    private let getOutingHistoryUseCase: any GetOutingHistoryUseCase

    public init (
        getOutingHistoryUseCase: any GetOutingHistoryUseCase
    ) {
        self.getOutingHistoryUseCase = getOutingHistoryUseCase
    }

    public struct State: Equatable {
        public var studentItems: [OutingHistoryEntity] = []
        public var searchText: String = ""

        public init() {}
    }

    public enum Action {
        case onAppear
        case outingHistoryResponse(TaskResult<[OutingHistoryEntity]>)
        case searchTextChanged(String)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return loadOutingHistory()
            case let .outingHistoryResponse(.success(students)):
                state.studentItems = students
                return .none
            case let .outingHistoryResponse(.failure(error)):
                return .none
            case let .searchTextChanged(searchText):
                state.searchText = searchText
                return .none
            }
        }
    }
}

extension OutingHistoryReducer {
    private func loadOutingHistory() -> Effect<Action> {
        .run { send in
            await send(.outingHistoryResponse(
                await TaskResult {
                    try await getOutingHistoryUseCase.execute()
                }
            ))
        }
    }
}

extension OutingHistoryReducer.State {
    var filteredStudentItems: [OutingHistoryEntity] {
        guard !searchText.isEmpty else { return studentItems }

        let keyword = searchText.replacingOccurrences(of: " ", with: "").lowercased()

        return studentItems.filter { data in
            let searchableText =
                "\(data.grade)\(data.classNum)\(String(format: "%02d", data.num))\(data.userName)"
                .lowercased()

            return searchableText.contains(keyword)
        }
    }
}
