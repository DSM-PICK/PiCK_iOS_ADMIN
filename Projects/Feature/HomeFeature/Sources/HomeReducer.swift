import ComposableArchitecture
import PiCK_iOS_DesignSystem
import HomeDomainInterface
import AcceptDomainInterface
import OutListDomainInterface
import ClassroomMoveListDomainInterface
import Combine

public struct HomeReducer: Reducer {
    private let getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol
    private let getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol

    private let getSelfStudyAndClassroomUseCase: any GetSelfStudyAndClassroomUseCase // 어드민 자감/다임 여부

    private let getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol // 외출 신청자 반별로 조회
    private let updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol // 외출 수락/거절
    private let getEarlyReturnByGradeUseCase: any GetEarlyReturnByGradeUseCaseProtocol // 조기귀가 신청자 반별로 조회
    private let updateEarlyReturnStatusUseCase: any UpdateEarlyReturnStatusUseCaseProtocol // 조기귀가 수락/거절

    private let getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase // 교실 이동자 층별로 조회
    private let getOutListUseCase: any GetOutListUseCase // 외출자 층별로 조회
    private let getEarlyReturnUseCase: any GetEarlyReturnUseCase // 조기귀가자 층별로 조회

    public init(
        getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol,
        getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol,
        getSelfStudyAndClassroomUseCase: any GetSelfStudyAndClassroomUseCase,
        getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol,
        updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol,
        getEarlyReturnByGradeUseCase: any GetEarlyReturnByGradeUseCaseProtocol,
        updateEarlyReturnStatusUseCase: any UpdateEarlyReturnStatusUseCaseProtocol,
        getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase,
        getOutListUseCase: any GetOutListUseCase,
        getEarlyReturnUseCase: any GetEarlyReturnUseCase
    ) {
        self.getSelfStudyDirectorUseCase = getSelfStudyDirectorUseCase
        self.getAdminSelfStudyInfoUseCase = getAdminSelfStudyInfoUseCase
        self.getSelfStudyAndClassroomUseCase = getSelfStudyAndClassroomUseCase
        self.getAllApplicationsUseCase = getAllApplicationsUseCase
        self.updateApplicationStatusUseCase = updateApplicationStatusUseCase
        self.getEarlyReturnByGradeUseCase = getEarlyReturnByGradeUseCase
        self.updateEarlyReturnStatusUseCase = updateEarlyReturnStatusUseCase
        self.getClassroomMoveByFloorUseCase = getClassroomMoveByFloorUseCase
        self.getOutListUseCase = getOutListUseCase
        self.getEarlyReturnUseCase = getEarlyReturnUseCase
    }

    public struct State: Equatable {
        public var selfStudyDirector: [SelfStudyDirectorEntity] = []
        public var adminSelfStudyTeacher: String?
        public var classroom: String = "0-0"
        public var floor: String = "0층"
        public var isHomeroomTeacher: Bool = false
        public var isSelfStudyTeacher: Bool = false
        public var showAlert: Bool = false
        public var alertSuccessType: SuccessType = .success
        public var alertMessage: String = ""

        // 내부용 리스트
        var earlyReturnList: [EarlyReturnEntity] = []
        var outList: [OutListEntity] = []
        var acceptList: [ApplicationEntity] = []
        var earlyReturnAcceptList: [EarlyReturnAcceptEntity] = []
        
        // View에서 사용할 합쳐진 리스트
        public var outingStudentList: [OutingStudentViewModel] = []
        public var outingAcceptList: [OutingAcceptViewModel] = []
        
        public var classroomMoveList: [ClassroomMoveListEntity] = []

        public init() {}
    }

    public enum Action {
        case fetchSelfStudyDirector(date: String)
        case selfStudyDirectorResponse(Result<[SelfStudyDirectorEntity], Error>)
        case fetchAdminSelfStudyInfo
        case adminSelfStudyInfoResponse(Result<String, Error>)

        case fetchSelfStudyAndClassroom
        case selfStudyAndClassroomResponse(TaskResult<GetSelfStudyAndClassroomEntity>)

        case acceptResponse(TaskResult<[ApplicationEntity]>)
        case earlyReturnAcceptListResponse(TaskResult<[EarlyReturnAcceptEntity]>)

        case acceptApplication(id: String)
        case rejectApplication(id: String)
        case acceptEarlyReturn(id: String)
        case rejectEarlyReturn(id: String)

        case updateStatusResponse(TaskResult<Void>)
        case updateEarlyReturnStatusResponse(TaskResult<Void>)

        case classroomMoveResponse(TaskResult<[ClassroomMoveListEntity]>)
        case outListResponse(TaskResult<[OutListEntity]>)
        case earlyReturnListResponse(TaskResult<[EarlyReturnEntity]>)

        case dismissAlert
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .fetchSelfStudyDirector(date):
                return .publisher {
                    getSelfStudyDirectorUseCase.execute(date: date)
                        .map { Action.selfStudyDirectorResponse(.success($0)) }
                        .catch { Just(Action.selfStudyDirectorResponse(.failure($0))) }
                }

            case let .selfStudyDirectorResponse(.success(director)):
                state.selfStudyDirector = director
                return .none

            case .selfStudyDirectorResponse(.failure):
                return .none

            case .fetchAdminSelfStudyInfo:
                return .publisher {
                    getAdminSelfStudyInfoUseCase.execute()
                        .map { Action.adminSelfStudyInfoResponse(.success($0)) }
                        .catch { Just(Action.adminSelfStudyInfoResponse(.failure($0))) }
                }

            case let .adminSelfStudyInfoResponse(.success(teacher)):
                state.adminSelfStudyTeacher = teacher
                return .none

            case .adminSelfStudyInfoResponse(.failure):
                return .none

            case .fetchSelfStudyAndClassroom:
                return .publisher {
                    getSelfStudyAndClassroomUseCase.execute()
                        .map { Action.selfStudyAndClassroomResponse(.success($0)) }
                        .catch { Just(Action.selfStudyAndClassroomResponse(.failure($0))) }
                }

            case let .selfStudyAndClassroomResponse(.success(data)):
                let grade = data.grade
                let classNum = data.classNum
                let selfStudyFloor = data.selfStudyFloor

                state.classroom = "\(grade)-\(classNum)"
                state.floor = "\(selfStudyFloor)층"

                var effects: [Effect<Action>] = []

                if selfStudyFloor != 0 {
                    state.isSelfStudyTeacher = true
                    effects.append(loadClassroomMoveList(floor: selfStudyFloor))
                    effects.append(loadOutList(floor: selfStudyFloor))
                    effects.append(loadEarlyReturnList(floor: selfStudyFloor))
                } else {
                    state.isSelfStudyTeacher = false
                }

                if grade != 0 && classNum != 0 {
                    state.isHomeroomTeacher = true
                    effects.append(loadAcceptList(grade: grade, classNum: classNum))
                    effects.append(loadEarlyReturnAcceptList(grade: grade, classNum: classNum))
                } else {
                    state.isHomeroomTeacher = false
                }

                return .merge(effects)

            case .selfStudyAndClassroomResponse(.failure):
                return .none

            case let .acceptResponse(.success(list)):
                state.acceptList = list
                state.outingAcceptList = combineAcceptLists(
                    acceptList: list,
                    earlyReturnAcceptList: state.earlyReturnAcceptList
                )
                return .none
            case .acceptResponse(.failure):
                return .none

            case let .earlyReturnAcceptListResponse(.success(students)):
                state.earlyReturnAcceptList = students
                state.outingAcceptList = combineAcceptLists(
                    acceptList: state.acceptList,
                    earlyReturnAcceptList: students
                )
                return .none
            case .earlyReturnAcceptListResponse(.failure):
                return .none

            case let .acceptApplication(id):
                return .run { send in
                    await send(
                        .updateStatusResponse(
                            await TaskResult {
                                try await updateApplicationStatusUseCase.execute(
                                    status: "OK",
                                    idList: [id]
                                )
                            }
                        )
                    )
                }
            case let .rejectApplication(id):
                return .run { send in
                    await send(
                        .updateStatusResponse(
                            await TaskResult {
                                try await updateApplicationStatusUseCase.execute(
                                    status: "NO",
                                    idList: [id]
                                )
                            }
                        )
                    )
                }
            case let .acceptEarlyReturn(id):
                return .run { send in
                    await send(
                        .updateEarlyReturnStatusResponse(
                            await TaskResult {
                                try await updateEarlyReturnStatusUseCase.execute(
                                    status: "OK",
                                    idList: [id]
                                )
                            }
                        )
                    )
                }
            case let .rejectEarlyReturn(id):
                return .run { send in
                    await send(
                        .updateEarlyReturnStatusResponse(
                            await TaskResult {
                                try await updateEarlyReturnStatusUseCase.execute(
                                    status: "NO",
                                    idList: [id]
                                )
                            }
                        )
                    )
                }

            case .updateStatusResponse(.success):
                state.alertSuccessType = .success
                state.alertMessage = "외출 처리를 성공했어요"
                state.showAlert = true

                let components = state.classroom.split(separator: "-").compactMap { Int($0) }
                if components.count == 2 {
                    return .merge(
                        loadAcceptList(grade: components[0], classNum: components[1]),
                        loadEarlyReturnAcceptList(grade: components[0], classNum: components[1])
                    )
                }
                return .none
            case .updateStatusResponse(.failure):
                state.alertSuccessType = .fail
                state.alertMessage = "외출 처리를 실패했어요"
                state.showAlert = true
                return .none

            case .updateEarlyReturnStatusResponse(.success):
                state.alertSuccessType = .success
                state.alertMessage = "조기귀가 처리를 성공했어요"
                state.showAlert = true

                let components = state.classroom.split(separator: "-").compactMap { Int($0) }
                if components.count == 2 {
                    return .merge(
                        loadAcceptList(grade: components[0], classNum: components[1]),
                        loadEarlyReturnAcceptList(grade: components[0], classNum: components[1])
                    )
                }
                return .none
            case .updateEarlyReturnStatusResponse(.failure):
                state.alertSuccessType = .fail
                state.alertMessage = "조기귀가 처리를 실패했어요"
                state.showAlert = true
                return .none

            case let .classroomMoveResponse(.success(students)):
                state.classroomMoveList = students
                return .none
            case .classroomMoveResponse(.failure(_)):
                return .none

            case let .outListResponse(.success(students)):
                state.outList = students
                state.outingStudentList = combineOutingLists(
                    outList: students,
                    earlyReturnList: state.earlyReturnList
                )
                return .none
            case .outListResponse(.failure):
                return .none

            case let .earlyReturnListResponse(.success(students)):
                state.earlyReturnList = students
                state.outingStudentList = combineOutingLists(
                    outList: state.outList,
                    earlyReturnList: students
                )
                return .none
            case .earlyReturnListResponse(.failure):
                return .none

            case .dismissAlert:
                state.showAlert = false
                return .none
            }
        }
    }
}

extension HomeReducer {
    private func loadAcceptList(grade: Int, classNum: Int) -> Effect<Action> {
        .publisher {
            getAllApplicationsUseCase.execute(grade: grade, classNum: classNum)
                .mapError { $0 as Error }
                .map { Action.acceptResponse(.success($0)) }
                .catch { Just(Action.acceptResponse(.failure($0))) }
        }
    }

    private func loadClassroomMoveList(floor: Int) -> Effect<
        Action> {
            .run { send in
                await send(
                    .classroomMoveResponse(
                        await TaskResult {
                            try await getClassroomMoveByFloorUseCase.execute(floor: floor)
                        }
                    )
                )
            }
        }

    private func loadOutList(floor: Int) -> Effect<Action> {
        .run { send in
            await send(
                .outListResponse(
                    await TaskResult {
                        try await getOutListUseCase.execute(floor: floor)
                    }
                )
            )
        }
    }

    private func loadEarlyReturnList(floor: Int) -> Effect<Action> {
        .run { send in
            await send(
                .earlyReturnListResponse(
                    await TaskResult {
                        try await getEarlyReturnUseCase.execute(floor: floor, status: "OK")
                    }
                )
            )
        }
    }
    
    private func loadEarlyReturnAcceptList(grade: Int, classNum: Int) -> Effect<Action> {
        .publisher {
            getEarlyReturnByGradeUseCase.execute(grade: grade, classNum: classNum)
                .mapError { $0 as Error }
                .map { Action.earlyReturnAcceptListResponse(.success($0)) }
                .catch { Just(Action.earlyReturnAcceptListResponse(.failure($0))) }
        }
    }

    private func combineOutingLists(
        outList: [OutListEntity],
        earlyReturnList: [EarlyReturnEntity]
    ) -> [OutingStudentViewModel] {
        let outViewModels = outList.map { OutingStudentViewModel(from: $0) }
        let earlyReturnViewModels = earlyReturnList.map { OutingStudentViewModel(from: $0) }
        
        let combined = outViewModels + earlyReturnViewModels
        
        return combined.sorted {
            ($0.grade, $0.classNum, $0.num) < ($1.grade, $1.classNum, $1.num)
        }
    }
    private func combineAcceptLists(
        acceptList: [ApplicationEntity],
        earlyReturnAcceptList: [EarlyReturnAcceptEntity]
    ) -> [OutingAcceptViewModel] {
        let outViewModels = acceptList.map { OutingAcceptViewModel(from: $0) }
        let earlyReturnViewModels = earlyReturnAcceptList.map { OutingAcceptViewModel(from: $0) }
        
        let combined = outViewModels + earlyReturnViewModels
        
        return combined.sorted {
            ($0.grade, $0.classNum, $0.num) < ($1.grade, $1.classNum, $1.num)
        }
    }
}
