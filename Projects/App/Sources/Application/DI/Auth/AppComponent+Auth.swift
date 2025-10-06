import NeedleFoundation
import AuthDomain
import AuthDomainInterface
import Moya

public extension AppComponent {
    var authProvider: MoyaProvider<AuthAPI> {
        shared {
            MoyaProvider<AuthAPI>()
        }
    }

    var localAuthDataSource: any LocalAuthDataSource {
        shared {
            LocalAuthDataSourceImpl(keychain: keychain)
        }
    }
    var remoteAuthDataSource: any RemoteAuthDataSource {
        shared {
            RemoteAuthDataSourceImpl(provider: authProvider)
        }
    }

    var authRepository: any AuthRepository {
        shared {
            AuthRepositoryImpl(
                remoteAuthDataSource: remoteAuthDataSource,
                localAuthDataSource: localAuthDataSource
            )
        }
    }

    var loginUseCase: any LoginUseCase {
        shared {
            LoginUseCaseImpl(repository: authRepository)
        }
    }

    var refreshTokenUseCase: any RefreshTokenUseCase {
        shared {
            RefreshTokenUseCaseImpl(repository: authRepository)
        }
    }
}