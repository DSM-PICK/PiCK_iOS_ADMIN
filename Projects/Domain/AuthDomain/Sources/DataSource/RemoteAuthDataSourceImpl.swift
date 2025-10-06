import Foundation
import AuthDomainInterface
import Moya
import RxMoya
import RxSwift

public class RemoteAuthDataSourceImpl: RemoteAuthDataSource {
    private let provider: MoyaProvider<AuthAPI>

    public init(provider: MoyaProvider<AuthAPI>) {
        self.provider = provider
    }

    public func login(req: LoginRequestParams) -> Single<TokenEntity> {
        provider.rx.request(.login(req))
            .map(LoginResponseDTO.self)
            .map { $0.toDomain() }
    }

    public func refreshToken() -> Completable {
        provider.rx.request(.refreshToken)
            .asCompletable()
    }
}
