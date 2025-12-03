import Foundation
import BugReportDomainInterface

public class BugReportRepositoryImpl: BugReportRepository {
    private let dataSource: BugReportDataSource

    public init(dataSource: BugReportDataSource) {
        self.dataSource = dataSource
    }

    public func uploadImages(images: [Data]) async throws -> [String] {
        try await dataSource.uploadImages(images: images)
    }

    public func submitBugReport(title: String, content: String, fileNames: [String]) async throws {
        try await dataSource.submitBugReport(title: title, content: content, fileNames: fileNames)
    }
}
