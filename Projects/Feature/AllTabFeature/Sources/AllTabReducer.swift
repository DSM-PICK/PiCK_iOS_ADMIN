
import ComposableArchitecture
import AllTabDomainInterface

public struct AllTabReducer: Reducer {
    private let getMyNameUseCase: any GetMyNameUseCaseProtocol

    public init(getMyNameUseCase: any GetMyNameUseCaseProtocol) {
        self.getMyNameUseCase = getMyNameUseCase
    }

    public struct State: Equatable {
        public var myName: MyNameEntity?
        public init() {}
    }

    public enum Action {
        case fetchMyName
        case myNameResponse(TaskResult<MyNameEntity>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchMyName:
                return .run { send in
                    await send(.myNameResponse(
                        await TaskResult { try await getMyNameUseCase.execute() }
                    ))
                }

            case let .myNameResponse(.success(myName)):
                state.myName = myName
                return .none

            case .myNameResponse(.failure):
                return .none
            }
        }
    }
}
