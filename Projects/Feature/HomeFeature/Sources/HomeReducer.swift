
import ComposableArchitecture
import HomeDomainInterface
import Combine

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
        case selfStudyDirectorResponse(Result<[SelfStudyDirectorEntity], Error>)
        case fetchAdminSelfStudyInfo
        case adminSelfStudyInfoResponse(Result<String, Error>)
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
            }
        }
    }
}
