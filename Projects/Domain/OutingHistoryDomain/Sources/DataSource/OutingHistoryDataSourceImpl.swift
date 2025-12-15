import Foundation
import BaseDomain
import Core
import Moya
import OutingHistoryDomainInterface

public final class OutingHistoryDataSourceImpl: OutingHistoryDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<OutingHistoryAPI>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<OutingHistoryAPI>(plugins: [MoyaLoggingPlugin()])
    }

    public func getOutingHistory() async throws -> [OutingHistoryResponseDTO] {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.getOutingHistory) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map([OutingHistoryResponseDTO].self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = OutingHistoryAPI.getOutingHistory.errorMap,
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
