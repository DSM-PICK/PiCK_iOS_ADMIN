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

    var remoteMailDataSource: any RemoteMailDataSource {
        shared {
            RemotMailDataSourceImpl(keychain: keychain)
        }
    }

    var authRepository: any AuthRepository {
        shared {
            AuthRepositoryImpl(
                keychain: keychain,
                localDataSource: localAuthDataSource,
                remoteDataSource: remoteAuthDataSource
            )
        }
    }

    var mailRepository: any MailRepository {
        shared {
            MailRepositoryImpl(
                remoteDataSource: remoteMailDataSource
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

    var secretKeyUseCase: any SecretKeyUseCase {
        shared {
            SecretKeyUseCaseImpl(repository: authRepository)
        }
    }

    var emailSendUseCase: any EmailSendUseCase {
        shared {
            EmailSendUseCaseImpl(repository: mailRepository)
        }
    }

    var codeCheckUseCase: any CodeCheckUseCase {
        shared {
            CodeCheckUseCaseImpl(repository: mailRepository)
        }
    }

    var signupUseCase: any SignupUseCase {
        shared {
            SignupUseCaseImpl(repository: authRepository)
        }
    }
}
