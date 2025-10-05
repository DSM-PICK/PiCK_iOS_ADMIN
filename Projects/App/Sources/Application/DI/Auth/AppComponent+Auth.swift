import NeedleFoundation
import AuthDomain
import AuthDomainInterface

public extension AppComponent {
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
                remoteAuthDataSource: remoteAuthDataSource,
                localAuthDataSource: localAuthDataSource
            )
        }
    }

    var loginUseCase: any LoginUseCase {
        shared {
            LoginUseCaseImpl(authRepository: authRepository)
        }
    }
}
