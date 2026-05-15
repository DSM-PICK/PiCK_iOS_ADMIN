import ComposableArchitecture
import CheckSelfStudyTeacherDomainInterface
import Foundation
import Combine

@Reducer
public struct CheckSelfStudyTeacherReducer: Reducer {
    private let fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol

    public init(
        fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol
    ) {
        self.fetchSelfStudyTeacherUseCase = fetchSelfStudyTeacherUseCase
    }

    @ObservableState
    public struct State: Equatable {
        public var isLoading: Bool = false
        public var teachers: [SelfStudyTeacherEntity] = []
        public var selectedDate: Date = Date()

        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case selfStudyTeacherResponse(TaskResult<[SelfStudyTeacherEntity]>)
    }

    private enum CancelID {
        case fetchSelfStudyTeacher
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.selectedDate), .onAppear:
                state.isLoading = true
                return fetchSelfStudyTeacher(date: state.selectedDate)

            case .binding:
                return .none

            case let .selfStudyTeacherResponse(.success(teachers)):
                state.teachers = teachers
                state.isLoading = false
                return .none

            case .selfStudyTeacherResponse(.failure):
                state.isLoading = false
                return .none
            }
        }
    }
}

private extension CheckSelfStudyTeacherReducer {
    func fetchSelfStudyTeacher(date: Date) -> Effect<Action> {
        let dateString = formatDate(date)

        return .publisher {
            fetchSelfStudyTeacherUseCase.execute(date: dateString)
                .map { Action.selfStudyTeacherResponse(.success($0)) }
                .catch { Just(Action.selfStudyTeacherResponse(.failure($0))) }
        }
        .cancellable(id: CancelID.fetchSelfStudyTeacher, cancelInFlight: true)
    }

    func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }
}
