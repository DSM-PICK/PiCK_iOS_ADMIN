import Foundation
import AcceptDomain
import AcceptDomainInterface

public extension AppComponent {
    var getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol {
        shared {
            GetAllApplicationsUseCase(repository: acceptRepository)
        }
    }

    var getApplicationsByFloorUseCase: any GetApplicationsByFloorUseCaseProtocol {
        shared {
            GetApplicationsByFloorUseCase(repository: acceptRepository)
        }
    }

    var getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol {
        shared {
            GetClassroomMovesUseCase(repository: acceptRepository)
        }
    }

    var updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol {
        shared {
            UpdateApplicationStatusUseCase(repository: acceptRepository)
        }
    }

    var updateClassroomMoveStatusUseCase: any UpdateClassroomMoveStatusUseCaseProtocol {
        shared {
            UpdateClassroomMoveStatusUseCase(repository: acceptRepository)
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
