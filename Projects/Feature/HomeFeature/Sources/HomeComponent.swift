import NeedleFoundation
import SwiftUI
import HomeFeatureInterface
import ComposableArchitecture
import HomeDomainInterface
import AllTabFeatureInterface
import PlanFeatureInterface
import SchoolMealFeatureInterface
import AcceptFeatureInterface

public protocol HomeDependency: NeedleFoundation.Dependency {
    var getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol { get }
    var getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol { get }
    var allTabFactory: any AllTabFactory { get }
    var planFactory: any PlanFactory { get }
    var schoolMealFactory: any SchoolMealFactory { get }
    var acceptFactory: any AcceptFactory { get }
}

public final class HomeComponent: Component<HomeDependency>, HomeFactory {
    public func makeView() -> AnyView {
        AnyView(
            HomeFeature(
                store: .init(
                    initialState: HomeReducer.State(),
                    reducer: {
                        HomeReducer(
                            getSelfStudyDirectorUseCase: self.dependency.getSelfStudyDirectorUseCase,
                            getAdminSelfStudyInfoUseCase: self.dependency.getAdminSelfStudyInfoUseCase
                        )
                    }
                ),
                allTabFactory: self.dependency.allTabFactory,
                planFactory: self.dependency.planFactory,
                schoolMealFactory: self.dependency.schoolMealFactory,
                acceptFactory: self.dependency.acceptFactory
            )
        )
    }
}
