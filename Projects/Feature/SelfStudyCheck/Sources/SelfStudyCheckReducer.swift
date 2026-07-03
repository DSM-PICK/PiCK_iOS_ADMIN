import Foundation
import ComposableArchitecture
import SelfStudyCheckDomainInterface
import Combine

@Reducer
public struct SelfStudyCheckReducer: Reducer {
    private let getStudentAttendanceUseCase: any GetStudentAttendanceUseCase
    private let saveAttendanceUseCase: any SaveAttendanceUseCase

    public init(
        getStudentAttendanceUseCase: any GetStudentAttendanceUseCase,
        saveAttendanceUseCase: any SaveAttendanceUseCase
    ) {
        self.getStudentAttendanceUseCase = getStudentAttendanceUseCase
        self.saveAttendanceUseCase = saveAttendanceUseCase
    }

    public enum Period: Int, CaseIterable, Equatable {
        case sixth = 6
        case seventh = 7
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

    @ObservableState
    public struct State: Equatable {
        public var studentItems: [StudentItem] = []
        public var initialStudentItems: [StudentItem] = []
        public var periods: [Period] = [.eighth, .ninth, .tenth]
        public var selectedPeriod: Period = .eighth
        public var selectedGrade: Int = 1
        public var selectedClass: Int = 1
        public var isLoading: Bool = false
        public var isSaving: Bool = false

        public var isChanged: Bool {
            studentItems != initialStudentItems
        }

        public init(isFriday: Bool = Calendar.current.component(.weekday, from: Date()) == 6) {
            if isFriday {
                self.periods = [.sixth, .seventh, .eighth, .ninth, .tenth]
                self.selectedPeriod = .sixth
            } else {
                self.periods = [.eighth, .ninth, .tenth]
                self.selectedPeriod = .eighth
            }
        }
    }

    public enum Action {
        case selectPeriod(Period)
        case selectGradeAndClass(grade: Int, classNum: Int)
        case fetchStudents
        case studentsResponse(TaskResult<[StudentItem]>)
        case updateStudentStatus(id: String, status: String)
        case saveAttendance
        case saveAttendanceResponse(TaskResult<Void>)
    }

    private func mapStatusToKorean(_ status: String) -> String {
        switch status.uppercased() {
        case "ATTENDANCE":
            return "출석"
        case "MOVEMENT":
            return "이동"
        case "HOME", "GO_HOME":
            return "귀가"
        case "OUTING", "GO_OUT":
            return "외출"
        case "FIELD_TRIP", "PICNIC":
            return "현체"
        case "EMPLOYMENT":
            return "취업중"
        case "TRUANCY":
            return "무단"
        case "ABSENCE":
            return "결과"
        default:
            return status
        }
    }

    public var body: some ReducerOf<Self> {
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
                return .publisher {
                    getStudentAttendanceUseCase.execute(
                        grade: state.selectedGrade,
                        classNum: state.selectedClass,
                        period: state.selectedPeriod.rawValue
                    )
                    .map { entities -> [StudentItem] in
                        entities.map { entity in
                            StudentItem(
                                id: entity.id,
                                grade: entity.grade,
                                classNum: entity.classNum,
                                num: entity.num,
                                userName: entity.userName,
                                status: mapStatusToKorean(entity.status)
                            )
                        }
                    }
                    .map { Action.studentsResponse(.success($0)) }
                    .catch { Just(Action.studentsResponse(.failure($0))) }
                }

            case let .studentsResponse(.success(students)):
                state.studentItems = students
                state.initialStudentItems = students
                state.isLoading = false
                return .none

            case .studentsResponse(.failure):
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

            case .saveAttendance:
                state.isSaving = true
                let attendances = state.studentItems.compactMap { item -> AttendanceUpdateRequestDTO? in
                    guard let status = AttendanceStatus.fromKorean(item.status) else {
                        return nil
                    }
                    return AttendanceUpdateRequestDTO(userId: item.id, status: status)
                }
                return .publisher {
                    saveAttendanceUseCase.execute(period: state.selectedPeriod.rawValue, attendances: attendances)
                        .map { Action.saveAttendanceResponse(.success(())) }
                        .catch { Just(Action.saveAttendanceResponse(.failure($0))) }
                }

            case .saveAttendanceResponse(.success):
                state.isSaving = false
                state.initialStudentItems = state.studentItems
                return .none

            case .saveAttendanceResponse(.failure):
                state.isSaving = false
                return .none
            }
        }
    }
}
