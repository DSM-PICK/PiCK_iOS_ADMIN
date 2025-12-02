import ComposableArchitecture
import CheckSelfStudyTeacherDomainInterface

public struct CheckSelfStudyTeacherReducer: Reducer {
    public init() {}

    public struct State: Equatable {
        public var isLoading: Bool = false
        public var teachers: [String] = []

        public init() {}
    }

    public enum Action {
        case onAppear
        case fetchTeachers
        case teachersResponse(Result<[String], Error>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                return .send(.fetchTeachers)

            case .fetchTeachers:
                state.isLoading = true
                return .run { send in
                    try await Task.sleep(nanoseconds: 1_000_000_000)
                    await send(.teachersResponse(.success(["김선생님", "이선생님", "박선생님"])))
                }

            case let .teachersResponse(.success(teachers)):
                state.teachers = teachers
                state.isLoading = false
                return .none

            case .teachersResponse(.failure):
                state.isLoading = false
                return .none
            }
        }
    }
}
