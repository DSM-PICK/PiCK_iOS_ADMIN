import Foundation
import AcceptDomain
import AcceptDomainInterface

public extension AppComponent {
    var getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol {
        shared {
            GetAllApplicationsUseCase(repository: acceptRepository)
        }
    }

    var updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol {
        shared {
            UpdateApplicationStatusUseCase(repository: acceptRepository)
        }
    }

    private var acceptRepository: AcceptRepository {
        shared {
            AcceptRepositoryImpl(dataSource: acceptDataSource)
        }
    }

    private var acceptDataSource: AcceptDataSource {
        shared {
            AcceptDataSourceImpl(keychain: keychain)
        }
    }
}
