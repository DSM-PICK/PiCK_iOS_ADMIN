import Foundation
import Combine

public protocol GetEarlyReturnByGradeUseCaseProtocol {
    func execute(grade: Int, classNum: Int) -> AnyPublisher<[EarlyReturnAcceptEntity], Error>
}
 
