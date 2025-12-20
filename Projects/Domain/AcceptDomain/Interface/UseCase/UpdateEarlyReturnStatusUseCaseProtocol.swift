import Foundation
import Combine

public protocol UpdateEarlyReturnStatusUseCaseProtocol {
    func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error>
}
