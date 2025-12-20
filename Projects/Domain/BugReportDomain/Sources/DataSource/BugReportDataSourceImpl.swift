import Foundation
import BaseDomain
import Core
import Combine

public final class BugReportDataSourceImpl: BaseRemoteDataSource<BugReportAPI>, BugReportDataSource {

    public func uploadImages(images: [Data]) -> AnyPublisher<[String], Error> {
        request(.uploadImage(images: images))
            .tryMap { response in
                try response.map([String].self)
            }
            .eraseToAnyPublisher()
    }

    public func submitBugReport(title: String, content: String, fileNames: [String]) -> AnyPublisher<Void, Error> {
        request(.bugReport(title: title, content: content, fileNames: fileNames))
            .tryMap { _ in () }
            .eraseToAnyPublisher()
    }
}
