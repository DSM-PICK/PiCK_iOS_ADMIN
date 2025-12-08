import ComposableArchitecture

public struct SelfStudyCheckReducer: Reducer {

    public init() {}

    public enum Period: Int, CaseIterable, Equatable {
        case eighth = 8
        case ninth = 9
        case tenth = 10

        var title: String {
            "\(rawValue)교시"
        }
    }

    public struct StudentItem: Equatable, Identifiable {
        public let id: String
        public let grade: Int
        public let classNum: Int
        public let num: Int
        public let userName: String
        public let status: String

        public init(id: String, grade: Int, classNum: Int, num: Int, userName: String, status: String) {
            self.id = id
            self.grade = grade
            self.classNum = classNum
            self.num = num
            self.userName = userName
            self.status = status
        }
    }

    public struct State: Equatable {
        public var studentItems: [StudentItem] = []
        public var selectedPeriod: Period = .eighth
        public var isLoading: Bool = false

        public init() {}
    }

    public enum Action {
        case selectPeriod(Period)
        case fetchStudents
        case studentsResponse([StudentItem])
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .selectPeriod(period):
                state.selectedPeriod = period
                return .send(.fetchStudents)

            case .fetchStudents:
                state.isLoading = true
                return .run { send in
                    let mockStudents: [StudentItem] = []
                    await send(.studentsResponse(mockStudents))
                }

            case let .studentsResponse(students):
                state.studentItems = students
                state.isLoading = false
                return .none
            }
        }
    }
}
