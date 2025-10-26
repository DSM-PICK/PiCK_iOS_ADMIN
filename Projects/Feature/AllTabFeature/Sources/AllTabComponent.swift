import NeedleFoundation
import SwiftUI
import AllTabFeatureInterface
import ComposableArchitecture
import AllTabDomainInterface
import AuthDomainInterface

public protocol AllTabDependency: NeedleFoundation.Dependency {
    var getMyNameUseCase: any GetMyNameUseCaseProtocol { get }
    var authRepository: any AuthRepository { get }
}

public final class AllTabComponent: Component<AllTabDependency>, AllTabFactory {
    public func makeView() -> AnyView {
        AnyView(
            AllTabFeature(
                store: .init(
                    initialState: AllTabReducer.State(),
                    reducer: {
                        AllTabReducer(
                            getMyNameUseCase: self.dependency.getMyNameUseCase,
                            authRepository: self.dependency.authRepository
                        )
                    }
                )
            )
        )
    }
}
