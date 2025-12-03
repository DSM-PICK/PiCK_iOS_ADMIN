import Foundation
import BugReportDomainInterface

public class UploadBugImagesUseCase: UploadBugImagesUseCaseProtocol {
    private let repository: BugReportRepository

    public init(repository: BugReportRepository) {
        self.repository = repository
    }

    public func execute(images: [Data]) async throws -> [String] {
        try await repository.uploadImages(images: images)
    }
}
