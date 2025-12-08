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
        public var selectedGrade: Int = 1
        public var selectedClass: Int = 1
        public var isLoading: Bool = false

        public init() {}
    }

    public enum Action {
        case selectPeriod(Period)
        case selectGradeAndClass(grade: Int, classNum: Int)
        case fetchStudents
        case studentsResponse([StudentItem])
        case updateStudentStatus(id: String, status: String)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .selectPeriod(period):
                state.selectedPeriod = period
                return .send(.fetchStudents)

            case let .selectGradeAndClass(grade, classNum):
                state.selectedGrade = grade
                state.selectedClass = classNum
                return .send(.fetchStudents)

            case .fetchStudents:
                state.isLoading = true
                return .run { send in
                    let mockStudents: [StudentItem] = [
                        StudentItem(id: "1", grade: 1, classNum: 1, num: 1, userName: "강해민", status: "출석"),
                        StudentItem(id: "2", grade: 1, classNum: 1, num: 2, userName: "김철수", status: "외출"),
                        StudentItem(id: "3", grade: 1, classNum: 1, num: 3, userName: "이영희", status: "출석"),
                        StudentItem(id: "4", grade: 1, classNum: 1, num: 4, userName: "박민수", status: "출석"),
                        StudentItem(id: "5", grade: 1, classNum: 1, num: 5, userName: "정수진", status: "외출"),
                        StudentItem(id: "6", grade: 1, classNum: 1, num: 6, userName: "최동욱", status: "출석"),
                        StudentItem(id: "7", grade: 1, classNum: 1, num: 7, userName: "한지민", status: "출석"),
                        StudentItem(id: "8", grade: 1, classNum: 1, num: 8, userName: "송유진", status: "외출")
                    ]
                    await send(.studentsResponse(mockStudents))
                }

            case let .studentsResponse(students):
                state.studentItems = students
                state.isLoading = false
                return .none

            case let .updateStudentStatus(id, status):
                if let index = state.studentItems.firstIndex(where: { $0.id == id }) {
                    state.studentItems[index] = StudentItem(
                        id: state.studentItems[index].id,
                        grade: state.studentItems[index].grade,
                        classNum: state.studentItems[index].classNum,
                        num: state.studentItems[index].num,
                        userName: state.studentItems[index].userName,
                        status: status
                    )
                }
                return .none
            }
        }
    }
}
