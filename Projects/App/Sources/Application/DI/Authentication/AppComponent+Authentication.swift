import NeedleFoundation
import AuthDomain
import AuthDomainInterface
import Moya
import Core
import BaseDomain

public extension AppComponent {
    var authProvider: MoyaProvider<AuthAPI> {
        shared {
            MoyaProvider<AuthAPI>(plugins: [MoyaLoggingPlugin()])
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

    var signinUseCase: any SigninUseCase {
        shared {
            SigninUseCaseImpl(repository: authRepository)
        }
    }

    var refreshTokenUseCase: any RefreshTokenUseCase {
        shared {
            RefreshTokenUseCaseImpl(repository: authRepository)
        }
    }
}
