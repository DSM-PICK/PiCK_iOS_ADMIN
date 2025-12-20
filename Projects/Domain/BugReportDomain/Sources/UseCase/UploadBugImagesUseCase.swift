import Foundation
import BugReportDomainInterface
import Combine

public class UploadBugImagesUseCase: UploadBugImagesUseCaseProtocol {
    private let repository: BugReportRepository

    public init(repository: BugReportRepository) {
        self.repository = repository
    }

    public func execute(images: [Data]) -> AnyPublisher<[String], Error> {
        repository.uploadImages(images: images)
    }
}
