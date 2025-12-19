import Foundation
import AcceptDomainInterface

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
