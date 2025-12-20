import Foundation
import Combine

public protocol BugReportRepository {
    func uploadImages(images: [Data]) -> AnyPublisher<[String], Error>
    func submitBugReport(title: String, content: String, fileNames: [String]) -> AnyPublisher<Void, Error>
}
