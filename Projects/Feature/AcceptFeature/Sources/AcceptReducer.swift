import ComposableArchitecture
import AcceptDomainInterface
import Combine

public struct AcceptReducer: Reducer {
    private let getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol
    private let getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol
    private let updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol

    public init(
        getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol,
        getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol,
        updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol
    ) {
        self.getAllApplicationsUseCase = getAllApplicationsUseCase
        self.getClassroomMovesUseCase = getClassroomMovesUseCase
        self.updateApplicationStatusUseCase = updateApplicationStatusUseCase
    }

    public enum ApplicationType: Equatable {
        case outgoing
        case classroomMove
    }

    public enum StudentItem: Equatable, Identifiable {
        case application(ApplicationEntity)
        case classroomMove(ClassroomMoveEntity)

        public var id: String {
            switch self {
            case .application(let entity):
                return entity.id
            case .classroomMove(let entity):
                return entity.id
            }
        }
    }

    public struct State: Equatable {
        public var studentItems: [StudentItem] = []
        public var selectedItemIds: Set<String> = []
        public var isLoading: Bool = false
        public var currentGrade: Int = 5
        public var currentClassNum: Int = 5
        public var currentType: ApplicationType = .outgoing

        public init() {}
    }

    public enum Action {
        case fetchApplications(type: ApplicationType, grade: Int, classNum: Int)
        case applicationsResponse(Result<[ApplicationEntity], Error>)
        case classroomMovesResponse(Result<[ClassroomMoveEntity], Error>)
        case toggleSelection(id: String)
        case approveSelectedApplications
        case rejectSelectedApplications
        case updateStatusResponse(Result<Void, Error>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .fetchApplications(type, grade, classNum):
                state.isLoading = true
                state.currentGrade = grade
                state.currentClassNum = classNum
                state.currentType = type
                state.selectedItemIds = []

                switch type {
                case .outgoing:
                    return .publisher {
                        getAllApplicationsUseCase.execute(grade: grade, classNum: classNum)
                            .map { Action.applicationsResponse(.success($0)) }
                            .catch { Just(Action.applicationsResponse(.failure($0))) }
                    }
                case .classroomMove:
                    return .publisher {
                        getClassroomMovesUseCase.execute(grade: grade, classNum: classNum)
                            .map { Action.classroomMovesResponse(.success($0)) }
                            .catch { Just(Action.classroomMovesResponse(.failure($0))) }
                    }
                }

            case let .applicationsResponse(.success(applications)):
                state.studentItems = applications.map { .application($0) }
                state.isLoading = false
                return .none

            case .applicationsResponse(.failure):
                state.isLoading = false
                return .none

            case let .classroomMovesResponse(.success(classroomMoves)):
                state.studentItems = classroomMoves.map { .classroomMove($0) }
                state.isLoading = false
                return .none

            case .classroomMovesResponse(.failure):
                state.isLoading = false
                return .none

            case let .toggleSelection(id):
                if state.selectedItemIds.contains(id) {
                    state.selectedItemIds.remove(id)
                } else {
                    state.selectedItemIds.insert(id)
                }
                return .none

            case .approveSelectedApplications:
                let idList = Array(state.selectedItemIds)
                guard !idList.isEmpty else { return .none }
                state.isLoading = true
                return .publisher {
                    updateApplicationStatusUseCase.execute(status: "OK", idList: idList)
                        .map { Action.updateStatusResponse(.success(())) }
                        .catch { Just(Action.updateStatusResponse(.failure($0))) }
                }

            case .rejectSelectedApplications:
                let idList = Array(state.selectedItemIds)
                guard !idList.isEmpty else { return .none }
                state.isLoading = true
                return .publisher {
                    updateApplicationStatusUseCase.execute(status: "NO", idList: idList)
                        .map { Action.updateStatusResponse(.success(())) }
                        .catch { Just(Action.updateStatusResponse(.failure($0))) }
                }

            case .updateStatusResponse(.success):
                state.isLoading = false
                state.selectedItemIds = []
                return .send(.fetchApplications(type: state.currentType, grade: state.currentGrade, classNum: state.currentClassNum))

            case .updateStatusResponse(.failure):
                state.isLoading = false
                return .none
            }
        }
    }
}
