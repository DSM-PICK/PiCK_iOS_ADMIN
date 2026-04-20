import Foundation
import Combine
import ClassroomMoveListDomainInterface
import ComposableArchitecture
import PiCK_iOS_DesignSystem

@Reducer
public struct ClassroomMoveListReducer: Reducer {
    private let getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase
    private let getClassroomMoveByClassroomUseCase: any GetClassroomMoveByClassroomUseCase

    public init(
        getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase,
        getClassroomMoveByClassroomUseCase: any GetClassroomMoveByClassroomUseCase
    ) {
        self.getClassroomMoveByFloorUseCase = getClassroomMoveByFloorUseCase
        self.getClassroomMoveByClassroomUseCase = getClassroomMoveByClassroomUseCase
    }

    @ObservableState
    public struct State: Equatable {
        public var currentType: ClassroomMoveListType = .floor
        public var isLoading: Bool = false

        public var selectedFloor: Int = 2
        public var selectedGrade: Int = 5 // 전체
        public var selectedClassNum: Int = 5 // 전체

        public var studentItems: [ClassroomMoveListEntity] = []
        public var errorMessage: String?

        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case fetchFloor(Int)
        case fetchClassroom(grade: Int, classNum: Int)
        case fetchResponse(TaskResult<[ClassroomMoveListEntity]>)
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding(\.currentType):
                state.studentItems = []
                state.isLoading = true
                state.errorMessage = nil
                if state.currentType == .floor {
                    return loadClassroomMoveListByFloor(floor: state.selectedFloor)
                } else {
                    return loadClassroomMoveListByFloor(floor: 5)
                }

            case .binding:
                return .none

            case .onAppear:
                state.isLoading = true
                return loadClassroomMoveListByFloor(floor: state.selectedFloor)
            case let .fetchFloor(floor):
                state.isLoading = true
                state.errorMessage = nil
                state.selectedFloor = floor
                return loadClassroomMoveListByFloor(floor: floor)
            case let .fetchClassroom(grade, classNum):
                state.isLoading = true
                state.errorMessage = nil
                state.selectedGrade = grade
                state.selectedClassNum = classNum
                if state.selectedGrade == 5 { // 반별로 조회는 전체 조회 X -> floor = 5로 대체
                    return loadClassroomMoveListByFloor(floor: 5)
                } else {
                    return loadClassroomMoveListByClassroom(
                        grade: state.selectedGrade,
                        classNum: state.selectedClassNum
                    )
                }
            case let .fetchResponse(.success(students)):
                state.isLoading = false
                state.studentItems = students
                return .none
            case let .fetchResponse(.failure(error)):
                state.isLoading = false
                state.errorMessage = error.localizedDescription
                state.studentItems = []
                return .none
            }
        }
    }
}

extension ClassroomMoveListReducer {
    private func loadClassroomMoveListByFloor(floor: Int) -> Effect<Action> {
        .publisher {
            getClassroomMoveByFloorUseCase.execute(floor: floor)
                .mapError { $0 as Error }
                .map { Action.fetchResponse(.success($0)) }
                .catch { Just(Action.fetchResponse(.failure($0))) }
        }
    }

    private func loadClassroomMoveListByClassroom(grade: Int, classNum: Int) -> Effect<Action> {
        .publisher {
            getClassroomMoveByClassroomUseCase.execute(grade: grade, classNum: classNum)
                .mapError { $0 as Error }
                .map { Action.fetchResponse(.success($0)) }
                .catch { Just(Action.fetchResponse(.failure($0))) }
        }
    }

    public enum ClassroomMoveListType: Equatable {
        case floor
        case classroom

        var displayText: String {
            switch self {
            case .floor: return "층으로"
            case .classroom: return "교실로"
            }
        }
    }
}
