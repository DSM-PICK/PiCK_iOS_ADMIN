import Foundation
import BugReportDomainInterface
import Combine

public class BugReportRepositoryImpl: BugReportRepository {
    private let dataSource: BugReportDataSource

    public init(dataSource: BugReportDataSource) {
        self.dataSource = dataSource
    }

    public func uploadImages(images: [Data]) -> AnyPublisher<[String], Error> {
        dataSource.uploadImages(images: images)
    }

    public func submitBugReport(title: String, content: String, fileNames: [String]) -> AnyPublisher<Void, Error> {
        dataSource.submitBugReport(title: title, content: content, fileNames: fileNames)
    }
}
