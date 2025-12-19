import Foundation
import HomeDomain
import HomeDomainInterface
import BaseDomain

public extension AppComponent {
    var getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol {
        shared {
            GetSelfStudyDirectorUseCase(repository: homeRepository)
        }
    }
    
    var getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol {
        shared {
            GetAdminSelfStudyInfoUseCase(repository: homeRepository)
        }
    }

    var getSelfStudyAndClassroomUseCase: any GetSelfStudyAndClassroomUseCase {
        shared {
            GetSelfStudyAndClassroomUseCaseImpl(repository: homeRepository)
        }
    }
    
    private var homeRepository: HomeRepository {
        shared {
            HomeRepositoryImpl(dataSource: homeDataSource)
        }
    }
    
    private var homeDataSource: HomeDataSource {
        shared {
            HomeDataSourceImpl(keychain: keychain)
        }
    }
}
