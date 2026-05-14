import Foundation
import SelfStudyCheckDomain
import SelfStudyCheckDomainInterface
import BaseDomain

public extension AppComponent {
    var getStudentAttendanceUseCase: any GetStudentAttendanceUseCase {
        shared {
            GetStudentAttendanceUseCaseImpl(repository: selfStudyCheckRepository)
        }
    }

    var saveAttendanceUseCase: any SaveAttendanceUseCase {
        shared {
            SaveAttendanceUseCaseImpl(repository: selfStudyCheckRepository)
        }
    }

    private var selfStudyCheckRepository: any SelfStudyCheckRepository {
        shared {
            SelfStudyCheckRepositoryImpl(dataSource: selfStudyCheckDataSource)
        }
    }

    private var selfStudyCheckDataSource: any SelfStudyCheckDataSource {
        shared {
            SelfStudyCheckDataSourceImpl(keychain: keychain)
        }
    }
}
