import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Foundation
import OutListDomainInterface

public struct OutListReducer: Reducer {
    private let getOutListUseCase: any GetOutListUseCase
    private let returnStudentsUseCase: any ReturnStudentsUseCase
    private let getEarlyReturnUseCase: any GetEarlyReturnUseCase

    public init(
        getOutListUseCase: any GetOutListUseCase,
        returnStudentsUseCase: any ReturnStudentsUseCase,
        getEarlyReturnUseCase: any GetEarlyReturnUseCase
    ) {
        self.getOutListUseCase = getOutListUseCase
        self.returnStudentsUseCase = returnStudentsUseCase
        self.getEarlyReturnUseCase = getEarlyReturnUseCase
    }

    public struct State: Equatable {
        public var studentItems: [OutListEntity] = []
        public var earlyReturnItems: [EarlyReturnEntity] = []
        public var currentFloor: Int = 5
        public var currentType: OutListType = .outing
        public var isLoading: Bool = false
        public var selectedStudents: Set<String> = []
        public var errorMessage: String? = nil
        public var hasAppeared = false
        public var showAlert = false
        public var alertSuccessType: SuccessType = .success
        public var alertMessage: String = ""

        public init() {}
    }

    public enum Action {
        case onAppear
        case floorChanged(Int)
        case fetchByType(type: OutListType)
        case outListResponse(TaskResult<[OutListEntity]>)
        case earlyReturnResponse(TaskResult<[EarlyReturnEntity]>)
        case studentTapped(String)
        case returnStudents
        case returnStudentsResponse(TaskResult<Void>)
        case clearError
        case dismissAlert
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                if state.hasAppeared { return .none }
                state.hasAppeared = true
                state.isLoading = true
                return loadOutList(floor: state.currentFloor)

            case let .floorChanged(floor):
                state.currentFloor = floor
                state.isLoading = true
                state.selectedStudents.removeAll()
                if state.currentType == .earlyReturn {
                    return loadEarlyReturn(floor: floor)
                } else {
                    return loadOutList(floor: floor)
                }

            case let .fetchByType(type):
                state.currentType = type
                state.isLoading = true
                state.selectedStudents.removeAll()
                if state.currentType == .outing {
                    return loadOutList(floor: state.currentFloor)
                } else {
                    return loadEarlyReturn(floor: state.currentFloor)
                }

            case .outListResponse(.success(let students)):
                state.isLoading = false
                state.studentItems = students
                return .none

            case let .outListResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none

            case let .earlyReturnResponse(.success(students)):
                state.isLoading = false
                state.earlyReturnItems = students
                return .none

            case let .earlyReturnResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                return .none

            case let .studentTapped(id):
                if state.selectedStudents.contains(id) {
                    state.selectedStudents.remove(id)
                } else {
                    state.selectedStudents.insert(id)
                }
                return .none

            case .returnStudents:
                let ids = Array(state.selectedStudents)
                return .run { send in
                    await send(.returnStudentsResponse(
                        await TaskResult {
                            try await returnStudentsUseCase.execute(ids: ids)
                        }
                    ))
                }

            case .returnStudentsResponse(.success):
                state.selectedStudents.removeAll()
                state.showAlert = true
                state.alertSuccessType = .success
                state.alertMessage = "복귀가 완료되었습니다!"
                return loadOutList(floor: state.currentFloor)

            case let .returnStudentsResponse(.failure(error)):
                state.showAlert = true
                state.alertSuccessType = .fail
                state.alertMessage = "복귀를 실패하였습니다"
                return .none

            case .clearError:
                state.errorMessage = nil
                return .none

            case .dismissAlert:
                state.showAlert = false
                return .none
            }
        }
    }
}

extension OutListReducer {
    private func loadOutList(floor: Int) -> Effect<Action> {
        .run { send in
            await send(.outListResponse(
                await TaskResult {
                    try await getOutListUseCase.execute(floor: floor)
                }
            ))
        }
    }

    private func loadEarlyReturn(floor: Int) -> Effect<Action> {
        .run { send in
            await send(.earlyReturnResponse(
                await TaskResult {
                    try await getEarlyReturnUseCase.execute(floor: floor, status: "OK")
                }
            ))
        }
    }

    public enum OutListType: Equatable {
        case outing
        case earlyReturn
    }
}
