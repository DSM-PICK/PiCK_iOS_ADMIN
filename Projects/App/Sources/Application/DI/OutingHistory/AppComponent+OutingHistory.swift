import Foundation
import OutingHistoryDomain
import OutingHistoryDomainInterface
import BaseDomain

public extension AppComponent {
    var getOutingHistoryUseCase: any GetOutingHistoryUseCase {
        shared {
            GetOutingHistoryUseCaseImpl(repository: outingHistoryRepository)
        }
    }

    private var outingHistoryRepository: OutingHistoryRepository {
        shared {
            OutingHistoryRepositoryImpl(dataSource: outingHistoryDataSource)
        }
    }

    private var outingHistoryDataSource: OutingHistoryDataSource {
        shared {
            OutingHistoryDataSourceImpl(keychain: keychain)
        }
    }
}
