import Foundation
import BugReportDomainInterface
import BugReportDomain

public extension AppComponent {
    var bugReportDataSource: BugReportDataSource {
        shared {
            BugReportDataSourceImpl(keychain: keychain)
        }
    }

    var bugReportRepository: BugReportRepository {
        shared {
            BugReportRepositoryImpl(dataSource: bugReportDataSource)
        }
    }

    var uploadBugImagesUseCase: UploadBugImagesUseCaseProtocol {
        shared {
            UploadBugImagesUseCase(repository: bugReportRepository)
        }
    }

    var submitBugReportUseCase: SubmitBugReportUseCaseProtocol {
        shared {
            SubmitBugReportUseCase(repository: bugReportRepository)
        }
    }
}
