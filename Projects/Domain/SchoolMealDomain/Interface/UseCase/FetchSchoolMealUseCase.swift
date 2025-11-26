import Foundation

public protocol FetchSchoolMealUseCaseProtocol {
    func execute(date: String) async throws -> SchoolMealEntity
}
