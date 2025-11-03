import NeedleFoundation
import SwiftUI
import PlanFeature
import PlanFeatureInterface
import PlanDomain
import PlanDomainInterface

public protocol PlanDependency: Dependency {}

public final class PlanComponent: Component<PlanDependency>, PlanFactory {
    public func makePlanView() -> AnyView {
        let domainComponent = PlanDomainComponent.shared
        
        let planComponent = PlanComponentImpl(
            fetchMonthAcademicScheduleUseCase: domainComponent.fetchMonthAcademicScheduleUseCase,
            fetchAcademicScheduleUseCase: domainComponent.fetchAcademicScheduleUseCase
        )
        
        return planComponent.makePlanView()
    }
}

extension AppComponent {
    public var planFactory: any PlanFactory {
        PlanComponent(parent: self)
    }
}
