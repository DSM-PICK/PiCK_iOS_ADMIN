import Foundation
import BaseDomain
import Core
import Moya

public class BugReportDataSourceImpl: BugReportDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<BugReportAPI>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<BugReportAPI>(plugins: [MoyaLoggingPlugin()])
    }

    public func uploadImages(images: [Data]) async throws -> [String] {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.uploadImage(images: images)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map(ImageUploadResponseDTO.self)
                        continuation.resume(returning: data.fileNames)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = BugReportAPI.uploadImage(images: images).errorMap,
                       let mappedError = errorMap[code] {
                        continuation.resume(throwing: mappedError)
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    public func submitBugReport(title: String, content: String, fileNames: [String]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.bugReport(title: title, content: content, fileNames: fileNames)) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = BugReportAPI.bugReport(title: title, content: content, fileNames: fileNames).errorMap,
                       let mappedError = errorMap[code] {
                        continuation.resume(throwing: mappedError)
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}
