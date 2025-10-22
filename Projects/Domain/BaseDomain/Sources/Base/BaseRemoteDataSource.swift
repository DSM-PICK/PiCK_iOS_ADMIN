import Combine
import Foundation
import Core
import Moya
import CombineMoya
import Utility

open class BaseRemoteDataSource<API: PiCKAPI> {
    private let keychain: any Keychain
    private let provider: MoyaProvider<API>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<API>(plugins: [MoyaLoggingPlugin()])
    }

    public func request(_ api: API) -> AnyPublisher<Response, Error> {
        provider.requestPublisher(api)
            .timeout(.seconds(120), scheduler: DispatchQueue.main)
            .tryCatch { error -> AnyPublisher<Response, Error> in
                guard let moyaError = error as? MoyaError,
                      let code = moyaError.response?.statusCode else {
                    throw error
                }
                throw api.errorMap?[code] ??
                    PiCKError.error(
                        message: (try? moyaError.response?
                            .mapJSON() as? NSDictionary)?["message"] as? String ?? "",
                        errorBody: [:]
                    )
            }
            .eraseToAnyPublisher()
    }
}
