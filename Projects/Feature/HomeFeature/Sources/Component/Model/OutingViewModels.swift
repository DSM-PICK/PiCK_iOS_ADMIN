import Foundation
import AcceptDomainInterface
import OutListDomainInterface

public struct OutingStudentViewModel: Equatable, Identifiable {
    public let id: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let userName: String
    public let type: OutgoingType

    init(from entity: OutListEntity) {
        self.id = entity.id
        self.grade = entity.grade
        self.classNum = entity.classNum
        self.num = entity.num
        self.userName = entity.userName
        self.type = .outgoing
    }

    init(from entity: EarlyReturnEntity) {
        self.id = entity.id
        self.grade = entity.grade
        self.classNum = entity.classNum
        self.num = entity.num
        self.userName = entity.userName
        self.type = .earlyReturn
    }
}


public struct OutingAcceptViewModel: Equatable, Identifiable {
    public let id: String
    public let grade: Int
    public let classNum: Int
    public let num: Int
    public let userName: String
    public let type: OutgoingType

    init(from entity: ApplicationEntity) {
        self.id = entity.id
        self.grade = entity.grade
        self.classNum = entity.classNum
        self.num = entity.num
        self.userName = entity.userName
        self.type = .outgoing
    }

    init(from entity: EarlyReturnAcceptEntity) {
        self.id = entity.id
        self.grade = entity.grade
        self.classNum = entity.classNum
        self.num = entity.num
        self.userName = entity.userName
        self.type = .earlyReturn
    }
}

public enum OutgoingType {
    case outgoing
    case earlyReturn

    public var title: String {
        switch self {
        case .outgoing:
            return "외출"
        case .earlyReturn:
            return "조기귀가"
        }
    }
}
