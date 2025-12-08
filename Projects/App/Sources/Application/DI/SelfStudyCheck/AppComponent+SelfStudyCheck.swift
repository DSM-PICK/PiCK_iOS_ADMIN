import Foundation
import NeedleFoundation
import SwiftUI
import SelfStudyCheckFeature
import SelfStudyCheckDomain
import SelfStudyCheckDomainInterface
import BaseDomain

public extension AppComponent {
    var getStudentAttendanceUseCase: any GetStudentAttendanceUseCase {
        shared {
            GetStudentAttendanceUseCaseImpl(repository: selfStudyCheckRepository)
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
