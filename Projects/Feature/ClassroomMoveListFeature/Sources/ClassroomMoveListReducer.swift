import Foundation
import ClassroomMoveListDomainInterface
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct ClassroomMoveListReducer: Reducer {
    public init() {}

    public struct State: Equatable {
        public var currentType: ClassroomMoveListType = .floor
        public var isLoading: Bool = false
        public var selectedGrade: String = ""
        public var selectedClassNum: String = ""

        public init() {}
    }
    public enum Action {
        case onAppear
        case currentTypeChanged(ClassroomMoveListReducer.ClassroomMoveListType)
        case fetchFloor(floor: Int)
        case fetchClassroom(grade: String, classNum: String)
    }
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                state.isLoading = true
                return .none
            case let .currentTypeChanged(current):
                state.currentType = current
                return .none
            case let .fetchFloor(floor):
                return .none
            case let .fetchClassroom(grade, classNum):
                return .none
            }
        }
    }
}

extension ClassroomMoveListReducer {
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
