import Foundation
import NeedleFoundation
import SwiftUI
import ClassroomMoveListFeature
import ClassroomMoveListFeatureInterface
import ClassroomMoveListDomain
import ClassroomMoveListDomainInterface
import BaseDomain

public extension AppComponent {
    var getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase {
        shared {
            GetClassroomMoveByFloorUseCaseImpl(repository: classroomMoveListRepository)
        }
    }

    var getClassroomMoveByClassroomUseCase: any GetClassroomMoveByClassroomUseCase {
        shared {
            GetClassroomMoveByClassroomImpl(repository: classroomMoveListRepository)
        }
    }

    private var classroomMoveListRepository: any ClassroomMoveListRepository {
        shared {
            ClassroomMoveListRepositoryImpl(dataSource: classroomMoveListDataSource)
        }
    }

    private var classroomMoveListDataSource: any ClassroomMoveListDataSource {
        shared {
            ClassroomMoveListDataSourceImpl(keychain: keychain)
        }
    }
}
