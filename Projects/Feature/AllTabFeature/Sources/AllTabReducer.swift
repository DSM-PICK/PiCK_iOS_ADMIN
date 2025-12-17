import ComposableArchitecture
import AllTabDomainInterface
import AuthDomainInterface
import Combine

public struct AllTabReducer: Reducer {
    private let getMyNameUseCase: any GetMyNameUseCaseProtocol
    private let authRepository: any AuthRepository

    public init(
        getMyNameUseCase: any GetMyNameUseCaseProtocol,
        authRepository: any AuthRepository
    ) {
        self.getMyNameUseCase = getMyNameUseCase
        self.authRepository = authRepository
    }

    public struct State: Equatable {
        public var myName: MyNameEntity?
        public var shouldLogout = false
        public var shouldResign = false

        public init() {}
    }

    public enum Action {
        case fetchMyName
        case myNameResponse(TaskResult<MyNameEntity>)
        case logoutButtonTapped
        case tokenRefreshNeeded
        case confirmResign
        case resignResponse(TaskResult<Void>)
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

            case let .myNameResponse(.failure(error)):
                return .none
                
            case .tokenRefreshNeeded:
                authRepository.logout()
                state.shouldLogout = true
                return .none

            case .logoutButtonTapped:
                authRepository.logout()
                state.shouldLogout = true
                return .none

            case .confirmResign:
                return .run { send in
                    await send(.resignResponse(
                        await TaskResult {
                            for try await _ in authRepository.resign().values {}
                        }
                    ))
                }

            case .resignResponse(.success):
                state.shouldResign = true
                return .none

            case .resignResponse(.failure):
                return .none
            }
        }
    }
}
