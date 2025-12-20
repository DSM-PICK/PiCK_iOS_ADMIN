import Foundation
import Combine

public protocol UpdateApplicationStatusUseCaseProtocol {
    func execute(status: String, idList: [String]) -> AnyPublisher<Void, Error>
}
