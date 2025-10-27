import Foundation
import AllTabDomain
import AllTabDomainInterface
import BaseDomain

public extension AppComponent {
    var getMyNameUseCase: any GetMyNameUseCaseProtocol {
        shared {
            GetMyNameUseCase(repository: allTabRepository)
        }
    }
    
    private var allTabRepository: AllTabRepository {
        shared {
            AllTabRepositoryImpl(dataSource: allTabDataSource)
        }
    }
    
    private var allTabDataSource: AllTabDataSource {
        shared {
            AllTabDataSourceImpl(keychain: keychain)
        }
    }
}
