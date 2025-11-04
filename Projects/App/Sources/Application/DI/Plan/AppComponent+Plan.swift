import Foundation
import NeedleFoundation
import SwiftUI
import PlanFeature
import PlanFeatureInterface
import PlanDomain
import PlanDomainInterface
import BaseDomain

public protocol PlanDependency: Dependency {
    var fetchAcademicScheduleUseCase: any FetchAcademicScheduleUseCaseProtocol { get }
    var fetchMonthAcademicScheduleUseCase: any FetchMonthAcademicScheduleUseCaseProtocol { get }
}

public final class PlanComponent: Component<PlanDependency>, PlanFactory {
    public func makePlanView() -> AnyView {
        let planComponent = PlanComponentImpl(
            fetchMonthAcademicScheduleUseCase: dependency.fetchMonthAcademicScheduleUseCase,
            fetchAcademicScheduleUseCase: dependency.fetchAcademicScheduleUseCase
        )
        
        return planComponent.makePlanView()
    }
}

public extension AppComponent {
    var fetchAcademicScheduleUseCase: any FetchAcademicScheduleUseCaseProtocol {
        shared {
            FetchAcademicScheduleUseCase(repository: planRepository)
        }
    }
    
    var fetchMonthAcademicScheduleUseCase: any FetchMonthAcademicScheduleUseCaseProtocol {
        shared {
            FetchMonthAcademicScheduleUseCase(repository: planRepository)
        }
    }
    
    private var planRepository: PlanRepository {
        shared {
            PlanRepositoryImpl(remoteDataSource: planRemoteDataSource)
        }
    }
    
    private var planRemoteDataSource: PlanRemoteDataSource {
        shared {
            PlanRemoteDataSourceImpl(keychain: keychain)
        }
    }
    
    var planFactory: any PlanFactory {
        PlanComponent(parent: self)
    }
}
