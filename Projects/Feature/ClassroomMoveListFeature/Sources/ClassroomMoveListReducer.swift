import Foundation
import ClassroomMoveListDomainInterface
import ComposableArchitecture
import PiCK_iOS_DesignSystem

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

    public struct State: Equatable {
        public var currentType: ClassroomMoveListType = .floor
        public var isLoading: Bool = false

        public var selectedFloor: Int = 2
        public var selectedGrade: Int = 5 // 전체
        public var selectedClassNum: Int = 5 // 전체

        public var studentItems: [ClassroomMoveListEntity] = []
        public var errorMessage: String? = nil

        public init() {}
    }
    public enum Action {
        case onAppear
        case currentTypeChanged(ClassroomMoveListReducer.ClassroomMoveListType)
        case fetchFloor(Int)
        case fetchClassroom(grade: Int, classNum: Int)
        case fetchFloorResponse(TaskResult<[ClassroomMoveListEntity]>)
    }
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return loadClassroomMoveListByFloor(floor: state.selectedFloor)
            case let .currentTypeChanged(current):
                state.currentType = current
                state.studentItems = []
                if current == .floor { // 반별로 조회는 전체 조회 X -> floor = 5로 대체
                    return loadClassroomMoveListByFloor(floor: state.selectedFloor)
                } else {
                    return loadClassroomMoveListByFloor(floor: 5)
                }
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
                    return loadClassroomMoveListByClassroom(grade: state.selectedGrade, classNum: state.selectedClassNum)
                }
            case let .fetchFloorResponse(.success(students)):
                state.isLoading = false
                state.studentItems = students
                return .none
            case let .fetchFloorResponse(.failure(error)):
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
        .run { send in
            await send(.fetchFloorResponse(
                await TaskResult {
                    try await getClassroomMoveByFloorUseCase.execute(floor: floor)
                }
            ))
        }
    }

    private func loadClassroomMoveListByClassroom(grade: Int, classNum: Int) -> Effect<Action> {
        .run { send in
            await send(.fetchFloorResponse(
                await TaskResult {
                    try await getClassroomMoveByClassroomUseCase.execute(grade: grade, classNum: classNum)
                }
            ))
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
