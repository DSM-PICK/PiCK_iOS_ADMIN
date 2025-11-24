import ComposableArchitecture
import AcceptDomainInterface
import Combine

public struct AcceptReducer: Reducer {
    private let getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol
    private let updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol

    public init(
        getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol,
        updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol
    ) {
        self.getAllApplicationsUseCase = getAllApplicationsUseCase
        self.updateApplicationStatusUseCase = updateApplicationStatusUseCase
    }

    public struct State: Equatable {
        public var applications: [ApplicationEntity] = []
        public var selectedApplicationIds: Set<String> = []
        public var isLoading: Bool = false
        public var currentGrade: Int = 5
        public var currentClassNum: Int = 5

        public init() {}
    }

    public enum Action {
        case fetchApplications(grade: Int, classNum: Int)
        case applicationsResponse(Result<[ApplicationEntity], Error>)
        case toggleSelection(id: String)
        case approveSelectedApplications
        case rejectSelectedApplications
        case updateStatusResponse(Result<Void, Error>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .fetchApplications(grade, classNum):
                state.isLoading = true
                state.currentGrade = grade
                state.currentClassNum = classNum
                state.selectedApplicationIds = []
                return .publisher {
                    getAllApplicationsUseCase.execute(grade: grade, classNum: classNum)
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

            case let .toggleSelection(id):
                if state.selectedApplicationIds.contains(id) {
                    state.selectedApplicationIds.remove(id)
                } else {
                    state.selectedApplicationIds.insert(id)
                }
                return .none

            case .approveSelectedApplications:
                let idList = Array(state.selectedApplicationIds)
                guard !idList.isEmpty else { return .none }
                state.isLoading = true
                return .publisher {
                    updateApplicationStatusUseCase.execute(status: "OK", idList: idList)
                        .map { Action.updateStatusResponse(.success(())) }
                        .catch { Just(Action.updateStatusResponse(.failure($0))) }
                }

            case .rejectSelectedApplications:
                let idList = Array(state.selectedApplicationIds)
                guard !idList.isEmpty else { return .none }
                state.isLoading = true
                return .publisher {
                    updateApplicationStatusUseCase.execute(status: "NO", idList: idList)
                        .map { Action.updateStatusResponse(.success(())) }
                        .catch { Just(Action.updateStatusResponse(.failure($0))) }
                }

            case .updateStatusResponse(.success):
                state.isLoading = false
                state.selectedApplicationIds = []
                return .send(.fetchApplications(grade: state.currentGrade, classNum: state.currentClassNum))

            case .updateStatusResponse(.failure):
                state.isLoading = false
                return .none
            }
        }
    }
}
