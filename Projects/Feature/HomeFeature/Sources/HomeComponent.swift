import NeedleFoundation
import SwiftUI
import HomeFeatureInterface
import ComposableArchitecture
import HomeDomainInterface
import AllTabFeatureInterface

public protocol HomeDependency: NeedleFoundation.Dependency {
    var getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol { get }
    var allTabFactory: any AllTabFactory { get }
}

public final class HomeComponent: Component<HomeDependency>, HomeFactory {
    public func makeView() -> AnyView {
        AnyView(
            HomeFeature(
                store: .init(
                    initialState: HomeReducer.State(),
                    reducer: {
                        HomeReducer(getSelfStudyDirectorUseCase: self.dependency.getSelfStudyDirectorUseCase)
                    }
                ),
                allTabFactory: self.dependency.allTabFactory
            )
        )
    }
}
