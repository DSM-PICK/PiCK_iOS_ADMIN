import ComposableArchitecture
import HomeDomainInterface
import AcceptDomainInterface
import OutListDomainInterface
import Combine

public struct HomeReducer: Reducer {
    private let getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol
    private let getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol
    private let getSelfStudyAndClassroomUseCase: any GetSelfStudyAndClassroomUseCase
    private let getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol // 외출 신청자 반별로 조회
    private let updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol // 외출 수락/거절

    public init(
        getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol,
        getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol,
        getSelfStudyAndClassroomUseCase: any GetSelfStudyAndClassroomUseCase,
        getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol,
        updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol
    ) {
        self.getSelfStudyDirectorUseCase = getSelfStudyDirectorUseCase
        self.getAdminSelfStudyInfoUseCase = getAdminSelfStudyInfoUseCase
        self.getSelfStudyAndClassroomUseCase = getSelfStudyAndClassroomUseCase
        self.getAllApplicationsUseCase = getAllApplicationsUseCase
        self.updateApplicationStatusUseCase = updateApplicationStatusUseCase
    }

    public struct State: Equatable {
        public var selfStudyDirector: [SelfStudyDirectorEntity] = []
        public var adminSelfStudyTeacher: String?
        public var classroom: String = "0-0"
        public var isHomeroomTeacher: Bool = false
        public var outList: [ApplicationEntity] = []

        public init() {}
    }

    public enum Action {
        case fetchSelfStudyDirector(date: String)
        case selfStudyDirectorResponse(Result<[SelfStudyDirectorEntity], Error>)
        case fetchAdminSelfStudyInfo
        case adminSelfStudyInfoResponse(Result<String, Error>)
        case fetchSelfStudyAndClassroom
        case selfStudyAndClassroomResponse(TaskResult<GetSelfStudyAndClassroomEntity>)
        case loadOutList(grade: Int, classNum: Int)
        case outListResponse(TaskResult<[ApplicationEntity]>)
        case acceptApplication(id: String)
        case rejectApplication(id: String)
        case updateStatusResponse(TaskResult<Void>)
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

                state.classroom = "\(grade)-\(classNum)"

                if grade != 0 && classNum != 0 {
                    state.isHomeroomTeacher = true
                    return loadOutList(grade: grade, classNum: classNum)
                } else {
                    state.isHomeroomTeacher = false
                    return .none
                }

            case .selfStudyAndClassroomResponse(.failure):
                return .none

            case let .outListResponse(.success(list)):
                state.outList = list
                return .none

            case .outListResponse(.failure):
                return .none

            case let .loadOutList(grade, classNum):
                return loadOutList(grade: grade, classNum: classNum)
                
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
                
            case .updateStatusResponse(.success):
                let components = state.classroom.split(separator: "-").compactMap { Int($0) }
                if components.count == 2 {
                    return loadOutList(grade: components[0], classNum: components[1])
                }
                return .none
                
            case .updateStatusResponse(.failure):
                return .none
            }
        }
    }
}

extension HomeReducer {
    private func loadOutList(grade: Int, classNum: Int) -> Effect<Action> {
        .run { send in
            await send(
                .outListResponse(
                    await TaskResult {
                        try await getAllApplicationsUseCase.execute(
                            grade: grade,
                            classNum: classNum
                        )
                    }
                )
            )
        }
    }
}
