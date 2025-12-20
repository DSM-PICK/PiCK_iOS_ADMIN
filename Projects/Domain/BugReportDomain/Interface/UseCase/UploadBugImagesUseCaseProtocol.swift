import Foundation
import Combine

public protocol UploadBugImagesUseCaseProtocol {
    func execute(images: [Data]) -> AnyPublisher<[String], Error>
}
