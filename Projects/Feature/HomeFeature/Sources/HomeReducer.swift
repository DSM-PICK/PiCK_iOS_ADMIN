
import ComposableArchitecture
import HomeDomainInterface

public struct HomeReducer: Reducer {
    private let getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol

    public init(getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol) {
        self.getSelfStudyDirectorUseCase = getSelfStudyDirectorUseCase
    }

    public struct State: Equatable {
        public var selfStudyDirector: [SelfStudyDirectorEntity] = []
        public init() {}
    }

    public enum Action {
        case fetchSelfStudyDirector
        case selfStudyDirectorResponse(TaskResult<[SelfStudyDirectorEntity]>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchSelfStudyDirector:
                return .run { send in
                    await send(.selfStudyDirectorResponse(TaskResult {
                        try await getSelfStudyDirectorUseCase.execute()
                    }))
                }

            case let .selfStudyDirectorResponse(.success(director)):
                state.selfStudyDirector = director
                return .none

            case .selfStudyDirectorResponse(.failure):
                return .none
            }
        }
    }
}
