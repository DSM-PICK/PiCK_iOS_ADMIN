import Foundation
import BugReportDomainInterface
import Combine

public class SubmitBugReportUseCase: SubmitBugReportUseCaseProtocol {
    private let repository: BugReportRepository

    public init(repository: BugReportRepository) {
        self.repository = repository
    }

    public func execute(title: String, content: String, fileNames: [String]) -> AnyPublisher<Void, Error> {
        repository.submitBugReport(title: title, content: content, fileNames: fileNames)
    }
}
