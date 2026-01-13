import Foundation
import NeedleFoundation
import SwiftUI
import SchoolMealFeature
import SchoolMealFeatureInterface
import SchoolMealDomain
import SchoolMealDomainInterface
import BaseDomain

public protocol SchoolMealDependency: Dependency {
    var fetchSchoolMealUseCase: any FetchSchoolMealUseCaseProtocol { get }
}

public final class SchoolMealComponent: Component<SchoolMealDependency>, SchoolMealFactory {
    public func makeSchoolMealView() -> AnyView {
        let schoolMealComponent = SchoolMealComponentImpl(
            fetchSchoolMealsUseCase: dependency.fetchSchoolMealUseCase
        )
        
        return schoolMealComponent.makeSchoolMealView()
    }
}

public extension AppComponent {
    var fetchSchoolMealUseCase: any FetchSchoolMealUseCaseProtocol {
        shared {
            FetchSchoolMealUseCase(repository: schoolMealRepository)
        }
    }

    private var schoolMealRepository: SchoolMealRepository {
        shared {
            SchoolMealRepositoryImpl(remoteDataSource: schoolMealRemoteDataSource)
        }
    }

    private var schoolMealRemoteDataSource: SchoolMealRemoteDataSource {
        shared {
            SchoolMealRemoteDataSourceImpl()
        }
    }

    var schoolMealFactory: any SchoolMealFactory {
        SchoolMealComponent(parent: self)
    }
}
