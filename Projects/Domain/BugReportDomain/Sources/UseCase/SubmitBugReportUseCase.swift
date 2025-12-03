import Foundation
import BugReportDomainInterface

public class SubmitBugReportUseCase: SubmitBugReportUseCaseProtocol {
    private let repository: BugReportRepository

    public init(repository: BugReportRepository) {
        self.repository = repository
    }

    public func execute(title: String, content: String, fileNames: [String]) async throws {
        try await repository.submitBugReport(title: title, content: content, fileNames: fileNames)
    }
}
