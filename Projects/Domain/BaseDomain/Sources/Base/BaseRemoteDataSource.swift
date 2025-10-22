import Combine
import Foundation
import Core
import Moya
import RxMoya
import RxSwift
import Utility

open class BaseRemoteDataSource<API: PiCKAPI> {
    private let keychain: any Keychain
    private let provider: MoyaProvider<API>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<API>(plugins: [MoyaLoggingPlugin()])
    }

    public func request(_ api: API) -> Single<Response> {
        return .create { single in
            var disposables: [Disposable] = []
                disposables.append(
                    self.defaultRequest(api)
                        .subscribe(
                            onSuccess: { single(.success($0)) },
                            onFailure: { single(.failure($0)) }
                        )
                )
            return Disposables.create(disposables)
        }
    }

    func defaultRequest(_ api: API) -> Single<Response> {
        return provider.rx
            .request(api)
            .timeout(.seconds(120), scheduler: MainScheduler.asyncInstance)
            .catch { error in
                guard let code = (error as? MoyaError)?.response?.statusCode else {
                    return .error(error)
                }
                return .error(
                    api.errorMap?[code] ??
                    PiCKError.error(
                        message: (try? (error as? MoyaError)?
                            .response?
                            .mapJSON() as? NSDictionary)?["message"] as? String ?? "",
                        errorBody: [:]
                    )
                )
            }
    }
}
