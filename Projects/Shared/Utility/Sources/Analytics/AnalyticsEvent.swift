import Foundation

// 새 이벤트는 여기에 case 를 추가하고 name / parameters 만 채우면 됨
// 개인정보(학생 이름, ID 등)는 파라미터로 보내지 않음
public enum AnalyticsEvent: Equatable {
    case screenView(name: String)
    case login
    case applicationDecision(type: ApplicationType, decision: Decision, source: Source, result: ResultType)
    case attendanceSave(result: ResultType)
    case studentReturn(result: ResultType)
    case bugReportSubmit(result: ResultType)
}

public extension AnalyticsEvent {
    enum ApplicationType: String {
        case outing
        case classroomMove = "classroom_move"
        case earlyReturn = "early_return"
    }

    enum Decision: String {
        case approve
        case reject
    }

    enum Source: String {
        case home
        case acceptList = "accept_list"
    }

    enum ResultType: String {
        case success
        case fail
    }
}

public extension AnalyticsEvent {
    var name: String {
        switch self {
        case .screenView:
            return "screen_view"
        case .login:
            return "login"
        case .applicationDecision:
            return "application_decision"
        case .attendanceSave:
            return "attendance_save"
        case .studentReturn:
            return "student_return"
        case .bugReportSubmit:
            return "bug_report_submit"
        }
    }

    var parameters: [String: Any]? {
        switch self {
        case let .screenView(name):
            return ["screen_name": name, "screen_class": name]
        case .login:
            return ["method": "id_password"]
        case let .applicationDecision(type, decision, source, result):
            return [
                "application_type": type.rawValue,
                "decision": decision.rawValue,
                "source": source.rawValue,
                "result": result.rawValue
            ]
        case let .attendanceSave(result),
             let .studentReturn(result),
             let .bugReportSubmit(result):
            return ["result": result.rawValue]
        }
    }
}
