import Foundation
import BaseDomain
import Core
import Moya

public class HomeDataSourceImpl: HomeDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<SelfStudyAPI>
    
    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<SelfStudyAPI>(plugins: [MoyaLoggingPlugin()])
    }
    
    public func getSelfStudyDirector(date: String) async throws -> [SelfStudyDirectorResponseDTO] {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.getSelfStudyDirector(date: date)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map([SelfStudyDirectorResponseDTO].self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = SelfStudyAPI.getSelfStudyDirector(date: date).errorMap,
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
