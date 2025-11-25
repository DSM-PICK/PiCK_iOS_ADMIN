import Combine
import Foundation
import Core
import Moya
import CombineMoya
import Utility

open class BaseRemoteDataSource<API: PiCKAPI> {
    private let keychain: any Keychain
    private let provider: MoyaProvider<API>
    private let refreshProvider: MoyaProvider<RefreshAPI>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<API>(plugins: [MoyaLoggingPlugin()])
        self.refreshProvider = MoyaProvider<RefreshAPI>(plugins: [MoyaLoggingPlugin()])
    }

    public func request(_ api: API) -> AnyPublisher<Response, Error> {
        provider.requestPublisher(api)
            .timeout(.seconds(120), scheduler: DispatchQueue.main)
            .tryCatch { [weak self] error -> AnyPublisher<Response, Error> in
                guard let self = self else { throw error }
                guard let moyaError = error as? MoyaError,
                      let code = moyaError.response?.statusCode else {
                    throw error
                }

                if code == 401 {
                    return self.refreshTokenAndRetry(api: api, originalError: moyaError)
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

    private func refreshTokenAndRetry(api: API, originalError: MoyaError) -> AnyPublisher<Response, Error> {
        refreshProvider.requestPublisher(.refreshToken)
            .tryMap { response -> Response in
                let tokenData = try response.map(RefreshTokenResponseDTO.self)
                JwtStore.shared.accessToken = tokenData.accessToken
                JwtStore.shared.refreshToken = tokenData.refreshToken
                return response
            }
            .flatMap { [weak self] _ -> AnyPublisher<Response, Error> in
                guard let self = self else {
                    return Fail(error: originalError as Error).eraseToAnyPublisher()
                }
                return self.provider.requestPublisher(api)
                    .timeout(.seconds(120), scheduler: DispatchQueue.main)
                    .mapError { $0 as Error }
                    .eraseToAnyPublisher()
            }
            .tryCatch { error -> AnyPublisher<Response, Error> in
                throw api.errorMap?[401] ?? originalError
            }
            .eraseToAnyPublisher()
    }
    
    public func requestText(_ api: API) -> AnyPublisher<String, Error> {
        request(api)
            .tryMap { response in
                guard let text = String(data: response.data, encoding: .utf8) else {
                    throw NSError(
                        domain: "EncodingError",
                        code: -1,
                        userInfo: [NSLocalizedDescriptionKey: "Failed to decode response as UTF-8"]
                    )
                }
                return text
            }
            .eraseToAnyPublisher()
    }
}
