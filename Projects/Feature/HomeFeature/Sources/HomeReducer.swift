
import ComposableArchitecture
import HomeDomainInterface

public struct HomeReducer: Reducer {
    private let getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol
    private let getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol

    public init(
        getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol,
        getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol
    ) {
        self.getSelfStudyDirectorUseCase = getSelfStudyDirectorUseCase
        self.getAdminSelfStudyInfoUseCase = getAdminSelfStudyInfoUseCase
    }

    public struct State: Equatable {
        public var selfStudyDirector: [SelfStudyDirectorEntity] = []
        public var adminSelfStudyTeacher: String?
        public init() {}
    }

    public enum Action {
        case fetchSelfStudyDirector(date: String)
        case selfStudyDirectorResponse(TaskResult<[SelfStudyDirectorEntity]>)
        case fetchAdminSelfStudyInfo
        case adminSelfStudyInfoResponse(TaskResult<String>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .fetchSelfStudyDirector(date):
                return .run { send in
                    await send(.selfStudyDirectorResponse(
                        await TaskResult { try await getSelfStudyDirectorUseCase.execute(date: date) }
                    ))
                }

            case let .selfStudyDirectorResponse(.success(director)):
                state.selfStudyDirector = director
                return .none

            case .selfStudyDirectorResponse(.failure):
                return .none
                
            case .fetchAdminSelfStudyInfo:
                return .run { send in
                    await send(.adminSelfStudyInfoResponse(
                        await TaskResult { try await getAdminSelfStudyInfoUseCase.execute() }
                    ))
                }
                
            case let .adminSelfStudyInfoResponse(.success(teacher)):
                state.adminSelfStudyTeacher = teacher
                return .none
                
            case .adminSelfStudyInfoResponse(.failure):
                // API 실패해도 UI는 그대로 유지
                return .none
            }
        }
    }
}
