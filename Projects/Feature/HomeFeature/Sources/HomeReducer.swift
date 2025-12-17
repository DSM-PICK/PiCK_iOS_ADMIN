import ComposableArchitecture
import HomeDomainInterface
import AllTabDomainInterface
import AcceptDomainInterface
import OutListDomainInterface
import Combine

public struct HomeReducer: Reducer {
    private let getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol
    private let getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol
    private let getMyNameUseCase: any GetMyNameUseCaseProtocol // 어드민 정보 조회
    private let getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol // 외출 신청자 반별로 조회
    private let updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol // 외출 수락/거절

    public init(
        getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol,
        getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol,
        getMyNameUseCase: any GetMyNameUseCaseProtocol,
        getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol,
        updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol
    ) {
        self.getSelfStudyDirectorUseCase = getSelfStudyDirectorUseCase
        self.getAdminSelfStudyInfoUseCase = getAdminSelfStudyInfoUseCase
        self.getMyNameUseCase = getMyNameUseCase
        self.getAllApplicationsUseCase = getAllApplicationsUseCase
        self.updateApplicationStatusUseCase = updateApplicationStatusUseCase
    }

    public struct State: Equatable {
        public var selfStudyDirector: [SelfStudyDirectorEntity] = []
        public var adminSelfStudyTeacher: String?
        public var classroom: String = "0-0"
        public init() {}
    }

    public enum Action {
        case fetchSelfStudyDirector(date: String)
        case selfStudyDirectorResponse(Result<[SelfStudyDirectorEntity], Error>)
        case fetchAdminSelfStudyInfo
        case adminSelfStudyInfoResponse(Result<String, Error>)
        case fetchMyName
        case myNameResponse(TaskResult<MyNameEntity>)
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

            case .fetchMyName:
                return .run { send in
                    await send(.myNameResponse(
                        await TaskResult { try await getMyNameUseCase.execute() }
                    ))
                }

            case let .myNameResponse(.success(myName)):
                    state.classroom = "\(myName.grade)-\(myName.classNum)"
                return .none

            case let .myNameResponse(.failure(error)):
                return .none
            }
        }
    }
}
