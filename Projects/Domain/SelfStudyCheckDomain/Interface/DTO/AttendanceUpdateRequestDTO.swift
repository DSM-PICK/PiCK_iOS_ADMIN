import Foundation

public struct AttendanceUpdateRequestDTO: Encodable {
    public let userId: String
    public let status: AttendanceStatus

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case status
    }

    public init(userId: String, status: AttendanceStatus) {
        self.userId = userId
        self.status = status
    }
}

public enum AttendanceStatus: String, Encodable {
    case attendance = "ATTENDANCE"
    case movement = "MOVEMENT"
    case goHome = "GO_HOME"
    case goOut = "GO_OUT"
    case picnic = "PICNIC"
    case employment = "EMPLOYMENT"

    public var korean: String {
        switch self {
        case .attendance:
            return "출석"
        case .movement:
            return "이동"
        case .goHome:
            return "귀가"
        case .goOut:
            return "외출"
        case .picnic:
            return "현체"
        case .employment:
            return "취업중"
        }
    }

    public static func fromKorean(_ korean: String) -> AttendanceStatus? {
        switch korean {
        case "출석":
            return .attendance
        case "이동":
            return .movement
        case "귀가":
            return .goHome
        case "외출":
            return .goOut
        case "현체":
            return .picnic
        case "취업중":
            return .employment
        default:
            return nil
        }
    }
}
