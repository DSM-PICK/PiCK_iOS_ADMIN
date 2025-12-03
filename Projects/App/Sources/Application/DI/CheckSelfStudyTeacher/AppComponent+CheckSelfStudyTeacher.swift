import Foundation
import CheckSelfStudyTeacherDomain
import CheckSelfStudyTeacherDomainInterface
import BaseDomain

public extension AppComponent {
    var fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol {
        shared {
            FetchSelfStudyTeacherUseCase(repository: checkSelfStudyTeacherRepository)
        }
    }

    private var checkSelfStudyTeacherRepository: CheckSelfStudyTeacherRepository {
        shared {
            CheckSelfStudyTeacherRepositoryImpl(dataSource: checkSelfStudyTeacherDataSource)
        }
    }

    private var checkSelfStudyTeacherDataSource: CheckSelfStudyTeacherDataSource {
        shared {
            CheckSelfStudyTeacherDataSourceImpl(keychain: keychain)
        }
    }
}
