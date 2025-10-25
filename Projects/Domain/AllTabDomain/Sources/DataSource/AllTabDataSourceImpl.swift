import Foundation
import BaseDomain
import Core
import Moya

public class AllTabDataSourceImpl: AllTabDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<AdminAPI>
    
    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<AdminAPI>(plugins: [MoyaLoggingPlugin()])
    }
    
    public func getMyName() async throws -> MyNameResponseDTO {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.getMyName) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map(MyNameResponseDTO.self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = AdminAPI.getMyName.errorMap,
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
