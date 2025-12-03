import Foundation

public protocol UploadBugImagesUseCaseProtocol {
    func execute(images: [Data]) async throws -> [String]
}
