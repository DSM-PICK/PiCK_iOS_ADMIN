import Foundation

public protocol BugReportDataSource {
    func uploadImages(images: [Data]) async throws -> [String]
    func submitBugReport(title: String, content: String, fileNames: [String]) async throws
}
