import Foundation
import BaseDomain
import Core
import Moya

public class AcceptDataSourceImpl: AcceptDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<AcceptAPI>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<AcceptAPI>(plugins: [MoyaLoggingPlugin()])
    }

    public func getAllApplications() async throws -> ApplicationListResponseDTO {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.getAllApplications) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map(ApplicationListResponseDTO.self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = AcceptAPI.getAllApplications.errorMap,
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
