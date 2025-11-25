import ComposableArchitecture
import AcceptDomainInterface
import Combine

public struct AcceptReducer: Reducer {
    private let getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol
    private let getApplicationsByFloorUseCase: any GetApplicationsByFloorUseCaseProtocol
    private let getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol
    private let updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol
    private let updateClassroomMoveStatusUseCase: any UpdateClassroomMoveStatusUseCaseProtocol

    public init(
        getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol,
        getApplicationsByFloorUseCase: any GetApplicationsByFloorUseCaseProtocol,
        getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol,
        updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol,
        updateClassroomMoveStatusUseCase: any UpdateClassroomMoveStatusUseCaseProtocol
    ) {
        self.getAllApplicationsUseCase = getAllApplicationsUseCase
        self.getApplicationsByFloorUseCase = getApplicationsByFloorUseCase
        self.getClassroomMovesUseCase = getClassroomMovesUseCase
        self.updateApplicationStatusUseCase = updateApplicationStatusUseCase
        self.updateClassroomMoveStatusUseCase = updateClassroomMoveStatusUseCase
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
        public var currentFloor: Int = 1
        public var currentType: ApplicationType = .outgoing
        public var toastMessage: String? = nil
        public var showToast: Bool = false
        public var shouldDismiss: Bool = false

        public init() {}
    }

    public enum Action {
        case fetchApplications(type: ApplicationType, grade: Int, classNum: Int)
        case fetchApplicationsByFloor(floor: Int)
        case applicationsResponse(Result<[ApplicationEntity], Error>)
        case classroomMovesResponse(Result<[ClassroomMoveEntity], Error>)
        case toggleSelection(id: String)
        case approveSelectedApplications
        case rejectSelectedApplications
        case updateStatusResponse(Result<String, Error>)
        case hideToast
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

            case let .fetchApplicationsByFloor(floor):
                state.isLoading = true
                state.currentFloor = floor
                state.currentType = .classroomMove
                state.selectedItemIds = []

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
                let typeText = state.currentType == .outgoing ? "외출 신청" : "교실 이동"

                switch state.currentType {
                case .outgoing:
                    return .publisher {
                        updateApplicationStatusUseCase.execute(status: "OK", idList: idList)
                            .map { Action.updateStatusResponse(.success("\(count)명의 \(typeText) 수락이 완료되었습니다!")) }
                            .catch { Just(Action.updateStatusResponse(.failure($0))) }
                    }
                case .classroomMove:
                    return .publisher {
                        updateClassroomMoveStatusUseCase.execute(status: "OK", idList: idList)
                            .map { Action.updateStatusResponse(.success("\(count)명의 \(typeText) 수락이 완료되었습니다!")) }
                            .catch { Just(Action.updateStatusResponse(.failure($0))) }
                    }
                }

            case .rejectSelectedApplications:
                let idList = Array(state.selectedItemIds)
                guard !idList.isEmpty else { return .none }
                state.isLoading = true

                let count = idList.count
                let typeText = state.currentType == .outgoing ? "외출 신청" : "교실 이동"

                switch state.currentType {
                case .outgoing:
                    return .publisher {
                        updateApplicationStatusUseCase.execute(status: "NO", idList: idList)
                            .map { Action.updateStatusResponse(.success("\(count)명의 \(typeText) 거절이 완료되었습니다!")) }
                            .catch { Just(Action.updateStatusResponse(.failure($0))) }
                    }
                case .classroomMove:
                    return .publisher {
                        updateClassroomMoveStatusUseCase.execute(status: "NO", idList: idList)
                            .map { Action.updateStatusResponse(.success("\(count)명의 \(typeText) 거절이 완료되었습니다!")) }
                            .catch { Just(Action.updateStatusResponse(.failure($0))) }
                    }
                }

            case let .updateStatusResponse(.success(message)):
                state.isLoading = false
                let removedIds = state.selectedItemIds
                state.studentItems.removeAll { item in
                    removedIds.contains(item.id)
                }
                state.selectedItemIds = []
                state.toastMessage = message
                state.showToast = true
                state.shouldDismiss = true
                return .none

            case .updateStatusResponse(.failure):
                state.isLoading = false
                state.toastMessage = "처리에 실패했습니다"
                state.showToast = true
                return .none

            case .hideToast:
                state.showToast = false
                state.toastMessage = nil
                return .none
            }
        }
    }
}
