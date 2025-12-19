import Foundation
import HomeDomainInterface

public struct GetSelfStudyAndClassroomResponseDTO: Decodable {
    public let selfStudyFloor: Int
    public let grade: Int
    public let classNum: Int

    enum CodingKeys: String, CodingKey {
        case selfStudyFloor = "self_study_floor"
        case grade
        case classNum = "class_num"
    }

    public init(selfStudyFloor: Int, grade: Int, classNum: Int) {
        self.selfStudyFloor = selfStudyFloor
        self.grade = grade
        self.classNum = classNum
    }
}

extension GetSelfStudyAndClassroomResponseDTO {
    public func toEntity() -> GetSelfStudyAndClassroomEntity {
        .init(
            selfStudyFloor: selfStudyFloor,
            grade: grade,
            classNum: classNum
        )
    }
}
