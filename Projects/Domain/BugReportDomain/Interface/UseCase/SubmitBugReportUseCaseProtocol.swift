import Foundation

public protocol SubmitBugReportUseCaseProtocol {
    func execute(title: String, content: String, fileNames: [String]) async throws
}
