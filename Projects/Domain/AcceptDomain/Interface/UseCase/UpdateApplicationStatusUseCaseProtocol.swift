import Foundation

public protocol UpdateApplicationStatusUseCaseProtocol {
    func execute(status: String, idList: [String]) async throws
}
