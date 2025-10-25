import NeedleFoundation
import SwiftUI
import HomeFeatureInterface
import ComposableArchitecture
import HomeDomainInterface

public protocol HomeDependency: NeedleFoundation.Dependency {
    var getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol { get }
}

public final class HomeComponent: Component<HomeDependency>, HomeFactory {
    public func makeView() -> AnyView {
        AnyView(HomeView(
            store: .init(
                initialState: HomeReducer.State(),
                reducer: {
                    HomeReducer(getSelfStudyDirectorUseCase: self.dependency.getSelfStudyDirectorUseCase)
                }
            )
        ))
    }
}
