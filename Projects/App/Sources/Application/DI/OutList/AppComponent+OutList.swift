import Foundation
import NeedleFoundation
import SwiftUI
import OutListFeature
import OutListFeatureInterface
import OutListDomain
import OutListDomainInterface
import BaseDomain

public extension AppComponent {
    var getOutListUseCase: any GetOutListUseCase {
        shared {
            GetOutListUseCaseImpl(repository: outListRepository)
        }
    }

    private var outListRepository: any OutListRepository {
        shared {
            OutListRepositoryImpl(dataSource: outListDataSource)
        }
    }

    private var outListDataSource: any OutListDataSource {
        shared {
            OutListDataSourceImpl(keychain: keychain)
        }
    }
}
