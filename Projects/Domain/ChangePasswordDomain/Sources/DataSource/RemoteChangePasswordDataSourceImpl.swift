import ChangePasswordDomainInterface
import BaseDomain
import Foundation
import Moya
import Core

public final class RemoteChangePasswordDataSourceImpl: RemoteChangePasswordDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<ChangePasswordAPI>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<ChangePasswordAPI>(plugins: [MoyaLoggingPlugin()])
    }

    public func changePassword(req: PasswordChangeRequestParams) async throws {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.changePassword(req)) { result in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = ChangePasswordAPI.changePassword(req).errorMap,
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
