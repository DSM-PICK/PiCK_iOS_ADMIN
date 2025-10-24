import NeedleFoundation
import AuthDomain
import AuthDomainInterface
import Moya
import Core

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
            RemoteAuthDataSourceImpl(keychain: keychain)
        }
    }

    var authRepository: any AuthRepository {
        shared {
            AuthRepositoryImpl(
                localDataSource: localAuthDataSource,
                remoteDataSource: remoteAuthDataSource
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
