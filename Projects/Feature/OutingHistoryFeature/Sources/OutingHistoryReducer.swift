import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Foundation
import Combine
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
        public var isLoading: Bool = false

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
                state.isLoading = true
                return loadOutingHistory()
            case let .outingHistoryResponse(.success(students)):
                state.isLoading = false
                state.studentItems = students
                return .none
            case .outingHistoryResponse(.failure(_)):
                // 에러 처리 필요
                state.isLoading = false
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
        .publisher {
            getOutingHistoryUseCase.execute()
                .mapError { $0 as Error }
                .map { Action.outingHistoryResponse(.success($0)) }
                .catch { Just(Action.outingHistoryResponse(.failure($0))) }
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
