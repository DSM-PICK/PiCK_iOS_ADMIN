import Foundation
import Combine

public protocol SubmitBugReportUseCaseProtocol {
    func execute(title: String, content: String, fileNames: [String]) -> AnyPublisher<Void, Error>
}
