import Foundation
import Combine

public protocol BugReportDataSource {
    func uploadImages(images: [Data]) -> AnyPublisher<[String], Error>
    func submitBugReport(title: String, content: String, fileNames: [String]) -> AnyPublisher<Void, Error>
}
