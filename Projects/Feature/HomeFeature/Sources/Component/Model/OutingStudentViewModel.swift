import Foundation
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
