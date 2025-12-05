import NeedleFoundation
import ChangePasswordDomain
import ChangePasswordDomainInterface
import ChangePasswordFeature
import Moya
import Core
import BaseDomain

public extension AppComponent {
    var changePasswordProvider: MoyaProvider<ChangePasswordAPI> {
        shared {
            MoyaProvider<ChangePasswordAPI>(plugins: [MoyaLoggingPlugin()])
        }
    }

    var remoteChangePasswordDataSource: any RemoteChangePasswordDataSource {
        shared {
            RemoteChangePasswordDataSourceImpl(keychain: keychain)
        }
    }

    var changePasswordRepository: any ChangePasswordRepository {
        shared {
            ChangePasswordRepositoryImpl(
                remoteChangePasswordDataSource: remoteChangePasswordDataSource
            )
        }
    }

    var passwordChangeUseCase: any PasswordChangeUseCase {
        shared {
            PasswordChangeUseCaseImpl(changePasswordRepository: changePasswordRepository)
        }
    }
}
