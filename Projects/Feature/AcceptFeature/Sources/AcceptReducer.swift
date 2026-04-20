import AcceptDomainInterface
import Combine
import ComposableArchitecture
import PiCK_iOS_DesignSystem

@Reducer
public struct AcceptReducer: Reducer {
    private let getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol
    private let getApplicationsByFloorUseCase: any GetApplicationsByFloorUseCaseProtocol
    private let getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol
    private let getEarlyReturnByGradeUseCase: any GetEarlyReturnByGradeUseCaseProtocol
    private let updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol
    private let updateClassroomMoveStatusUseCase: any UpdateClassroomMoveStatusUseCaseProtocol
    private let updateEarlyReturnStatusUseCase: any UpdateEarlyReturnStatusUseCaseProtocol

    public init(
        getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol,
        getApplicationsByFloorUseCase: any GetApplicationsByFloorUseCaseProtocol,
        getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol,
        getEarlyReturnByGradeUseCase: any GetEarlyReturnByGradeUseCaseProtocol,
        updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol,
        updateClassroomMoveStatusUseCase: any UpdateClassroomMoveStatusUseCaseProtocol,
        updateEarlyReturnStatusUseCase: any UpdateEarlyReturnStatusUseCaseProtocol
    ) {
        self.getAllApplicationsUseCase = getAllApplicationsUseCase
        self.getApplicationsByFloorUseCase = getApplicationsByFloorUseCase
        self.getClassroomMovesUseCase = getClassroomMovesUseCase
        self.getEarlyReturnByGradeUseCase = getEarlyReturnByGradeUseCase
        self.updateApplicationStatusUseCase = updateApplicationStatusUseCase
        self.updateClassroomMoveStatusUseCase = updateClassroomMoveStatusUseCase
        self.updateEarlyReturnStatusUseCase = updateEarlyReturnStatusUseCase
    }

    public enum StudentItem: Equatable, Identifiable {
        case application(ApplicationEntity)
        case classroomMove(ClassroomMoveEntity)
        case earlyReturn(EarlyReturnAcceptEntity)

        public var id: String {
            switch self {
            case .application(let entity):
                return entity.id
            case .classroomMove(let entity):
                return entity.id
            case .earlyReturn(let entity):
                return entity.id
            }
        }
    }

    @ObservableState
    public struct State: Equatable {
        public var studentItems: [StudentItem] = []
        public var selectedItemIds: Set<String> = []
        public var isLoading: Bool = false
        public var currentGrade: Int = 5
        public var currentClassNum: Int = 5
        public var currentFloor: Int = 3
        public var currentType: ApplicationType = .outgoing
        public var showAlert = false
        public var alertSuccessType: SuccessType = .success
        public var alertMessage: String = ""

        public init() {}
    }

    public enum Action {
        case fetchApplications(type: ApplicationType, grade: Int, classNum: Int)
        case fetchApplicationsByFloor(floor: Int)
        case applicationsResponse(Result<[ApplicationEntity], Error>)
        case classroomMovesResponse(Result<[ClassroomMoveEntity], Error>)
        case earlyReturnResponse(Result<[EarlyReturnAcceptEntity], Error>)
        case toggleSelection(id: String)
        case approveSelectedApplications
        case rejectSelectedApplications
        case updateStatusResponse(Result<String, Error>)
        case dismissAlert
    }

    public var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case let .fetchApplications(type, grade, classNum):
                state.isLoading = true
                state.currentGrade = grade
                state.currentClassNum = classNum
                state.currentType = type
                state.selectedItemIds = []
                state.studentItems = []

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
                case .earlyReturn:
                    return .publisher {
                        getEarlyReturnByGradeUseCase.execute(grade: grade, classNum: classNum)
                            .map { Action.earlyReturnResponse(.success($0)) }
                            .catch { Just(Action.earlyReturnResponse(.failure($0))) }
                    }
                }

            case let .fetchApplicationsByFloor(floor):
                state.isLoading = true
                state.currentFloor = floor
                state.currentType = .classroomMove
                state.selectedItemIds = []
                state.studentItems = []

                return .publisher {
                    getApplicationsByFloorUseCase.execute(floor: floor)
                        .map { Action.classroomMovesResponse(.success($0)) }
                        .catch { Just(Action.classroomMovesResponse(.failure($0))) }
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

            case let .earlyReturnResponse(.success(earlyReturns)):
                state.studentItems = earlyReturns.map { .earlyReturn($0) }
                state.isLoading = false
                return .none

            case .earlyReturnResponse(.failure):
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

                let count = idList.count
                let typeText: String
                switch state.currentType {
                case .outgoing:
                    typeText = "외출 신청"
                case .classroomMove:
                    typeText = "교실 이동"
                case .earlyReturn:
                    typeText = "조기 귀가"
                }
                let currentType = state.currentType

                return .publisher {
                    let publisher: AnyPublisher<Void, Error>
                    switch currentType {
                    case .outgoing:
                        publisher = updateApplicationStatusUseCase.execute(status: "OK", idList: idList)
                    case .classroomMove:
                        publisher = updateClassroomMoveStatusUseCase.execute(status: "OK", idList: idList)
                    case .earlyReturn:
                        publisher = updateEarlyReturnStatusUseCase.execute(status: "OK", idList: idList)
                    }

                    return publisher
                        .map { Action.updateStatusResponse(.success("\(count)명의 \(typeText) 수락이 완료되었습니다!")) }
                        .catch { Just(Action.updateStatusResponse(.failure($0))) }
                }

            case .rejectSelectedApplications:
                let idList = Array(state.selectedItemIds)
                guard !idList.isEmpty else { return .none }
                state.isLoading = true

                let count = idList.count
                let typeText: String
                switch state.currentType {
                case .outgoing:
                    typeText = "외출 신청"
                case .classroomMove:
                    typeText = "교실 이동"
                case .earlyReturn:
                    typeText = "조기 귀가"
                }
                let currentType = state.currentType

                return .publisher {
                    let publisher: AnyPublisher<Void, Error>
                    switch currentType {
                    case .outgoing:
                        publisher = updateApplicationStatusUseCase.execute(status: "NO", idList: idList)
                    case .classroomMove:
                        publisher = updateClassroomMoveStatusUseCase.execute(status: "NO", idList: idList)
                    case .earlyReturn:
                        publisher = updateEarlyReturnStatusUseCase.execute(status: "NO", idList: idList)
                    }

                    return publisher
                        .map { Action.updateStatusResponse(.success("\(count)명의 \(typeText) 거절이 완료되었습니다!")) }
                        .catch { Just(Action.updateStatusResponse(.failure($0))) }
                }

            case let .updateStatusResponse(.success(message)):
                state.isLoading = false
                let removedIds = state.selectedItemIds
                state.studentItems.removeAll { item in
                    removedIds.contains(item.id)
                }
                state.selectedItemIds = []
                state.alertSuccessType = .success
                state.alertMessage = message
                state.showAlert = true
                return .none

            case .updateStatusResponse(.failure):
                state.isLoading = false
                state.alertMessage = "처리를 실패했습니다"
                state.showAlert = true
                state.alertSuccessType = .fail
                return .none

            case .dismissAlert:
                state.showAlert = false
                return .none
            }
        }
    }
}
