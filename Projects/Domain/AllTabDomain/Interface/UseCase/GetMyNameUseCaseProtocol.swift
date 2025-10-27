import Foundation

public protocol GetMyNameUseCaseProtocol {
    func execute() async throws -> MyNameEntity
}
