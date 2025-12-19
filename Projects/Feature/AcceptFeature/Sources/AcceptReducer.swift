import ComposableArchitecture
import AcceptDomainInterface

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
        case earlyReturn(EarlyReturnEntity)

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
        case earlyReturnResponse(Result<[EarlyReturnEntity], Error>)
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
                state.studentItems = []

                switch type {
                case .outgoing:
                    return .run { send in
                        let result = await TaskResult {
                            try await getAllApplicationsUseCase.execute(grade: grade, classNum: classNum)
                        }
                        await send(.applicationsResponse(Result(result)))
                    }
                case .classroomMove:
                    return .run { send in
                        let result = await TaskResult {
                            try await getClassroomMovesUseCase.execute(grade: grade, classNum: classNum)
                        }
                        await send(.classroomMovesResponse(Result(result)))
                    }
                case .earlyReturn:
                    return .run { send in
                        let result = await TaskResult {
                            try await getEarlyReturnByGradeUseCase.execute(grade: grade, classNum: classNum)
                        }
                        await send(.earlyReturnResponse(Result(result)))
                    }
                }

            case let .fetchApplicationsByFloor(floor):
                state.isLoading = true
                state.currentFloor = floor
                state.currentType = .classroomMove
                state.selectedItemIds = []
                state.studentItems = []

                return .run { send in
                    let result = await TaskResult {
                        try await getApplicationsByFloorUseCase.execute(floor: floor)
                    }
                    await send(.classroomMovesResponse(Result(result)))
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

                return .run { send in
                    let result = await TaskResult {
                        switch currentType {
                        case .outgoing:
                            try await updateApplicationStatusUseCase.execute(status: "OK", idList: idList)
                        case .classroomMove:
                            try await updateClassroomMoveStatusUseCase.execute(status: "OK", idList: idList)
                        case .earlyReturn:
                            try await updateEarlyReturnStatusUseCase.execute(status: "OK", idList: idList)
                        }
                    }

                    switch result {
                    case .success:
                        await send(.updateStatusResponse(.success("\(count)명의 \(typeText) 수락이 완료되었습니다!")))
                    case .failure(let error):
                        await send(.updateStatusResponse(.failure(error)))
                    }
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

                return .run { send in
                    let result = await TaskResult {
                        switch currentType {
                        case .outgoing:
                            try await updateApplicationStatusUseCase.execute(status: "NO", idList: idList)
                        case .classroomMove:
                            try await updateClassroomMoveStatusUseCase.execute(status: "NO", idList: idList)
                        case .earlyReturn:
                            try await updateEarlyReturnStatusUseCase.execute(status: "NO", idList: idList)
                        }
                    }

                    switch result {
                    case .success:
                        await send(.updateStatusResponse(.success("\(count)명의 \(typeText) 거절이 완료되었습니다!")))
                    case .failure(let error):
                        await send(.updateStatusResponse(.failure(error)))
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
