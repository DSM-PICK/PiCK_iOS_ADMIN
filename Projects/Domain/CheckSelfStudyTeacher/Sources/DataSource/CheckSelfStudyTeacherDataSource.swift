import Foundation
import Combine

public protocol CheckSelfStudyTeacherDataSource {
    func getSelfStudyTeacher(date: String) -> AnyPublisher<[SelfStudyTeacherResponseDTO], Error>
}
