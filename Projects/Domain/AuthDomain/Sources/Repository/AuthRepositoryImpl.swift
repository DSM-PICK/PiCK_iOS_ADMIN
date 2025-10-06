import Foundation
import AuthDomainInterface
import RxSwift

public class AuthRepositoryImpl: AuthRepository {
    private let remoteAuthDataSource: RemoteAuthDataSource
    private let localAuthDataSource: LocalAuthDataSource

    public init(
        remoteAuthDataSource: RemoteAuthDataSource,
        localAuthDataSource: LocalAuthDataSource
    ) {
        self.remoteAuthDataSource = remoteAuthDataSource
        self.localAuthDataSource = localAuthDataSource
    }

    public func login(req: LoginRequestParams) -> Completable {
        return remoteAuthDataSource.login(req: req)
            .do(onSuccess: { [weak self] tokenEntity in
                self?.saveTokens(tokenEntity)
            })
            .asCompletable()
    }

    public func refreshToken() -> Completable {
        return remoteAuthDataSource.refreshToken()
    }

    private func saveTokens(_ tokenEntity: TokenEntity) {
        localAuthDataSource.saveAccessToken(tokenEntity.accessToken)
        localAuthDataSource.saveRefreshToken(tokenEntity.refreshToken)
        localAuthDataSource.saveAccessExp(tokenEntity.accessExp)
        localAuthDataSource.saveRefreshExp(tokenEntity.refreshExp)
    }
}
