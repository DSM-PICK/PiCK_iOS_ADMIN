
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
        case fetchSelfStudyDirector(date: String)
        case selfStudyDirectorResponse(TaskResult<[SelfStudyDirectorEntity]>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .fetchSelfStudyDirector(date):
                return .run { send in
                    await send(.selfStudyDirectorResponse(
                        await TaskResult { try await getSelfStudyDirectorUseCase.execute(date: date) }
                    ))
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
