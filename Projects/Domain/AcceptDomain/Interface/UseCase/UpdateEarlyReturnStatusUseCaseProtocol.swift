import Foundation

public protocol UpdateEarlyReturnStatusUseCaseProtocol {
    func execute(status: String, idList: [String]) async throws
}
