import Foundation

public protocol ReturnStudentsUseCase {
    func execute(ids: [String]) async throws
}
