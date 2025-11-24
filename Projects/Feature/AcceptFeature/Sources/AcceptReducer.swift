import ComposableArchitecture
import AcceptDomainInterface
import Combine

public struct AcceptReducer: Reducer {
    private let getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol

    public init(
        getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol
    ) {
        self.getAllApplicationsUseCase = getAllApplicationsUseCase
    }

    public struct State: Equatable {
        public var applications: [ApplicationEntity] = []
        public var isLoading: Bool = false

        public init() {}
    }

    public enum Action {
        case fetchAllApplications
        case applicationsResponse(Result<[ApplicationEntity], Error>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .fetchAllApplications:
                state.isLoading = true
                return .publisher {
                    getAllApplicationsUseCase.execute()
                        .map { Action.applicationsResponse(.success($0)) }
                        .catch { Just(Action.applicationsResponse(.failure($0))) }
                }

            case let .applicationsResponse(.success(applications)):
                state.applications = applications
                state.isLoading = false
                return .none

            case .applicationsResponse(.failure):
                state.isLoading = false
                return .none
            }
        }
    }
}
