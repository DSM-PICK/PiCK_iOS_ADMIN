import Foundation

public protocol GetMealUseCaseProtocol {
    func execute(date: String) async throws -> SchoolMealEntity
}
