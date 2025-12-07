import Foundation

public protocol GetEarlyReturnUseCase {
    func execute() async throws -> [EarlyReturnEntity]
}
