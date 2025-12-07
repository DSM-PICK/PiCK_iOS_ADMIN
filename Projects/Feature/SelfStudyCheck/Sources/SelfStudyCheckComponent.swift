import NeedleFoundation
import SwiftUI
import SelfStudyCheckFeatureInterface
import ComposableArchitecture

public protocol SelfStudyCheckDependency: NeedleFoundation.Dependency {
}

public final class SelfStudyCheckComponent: Component<SelfStudyCheckDependency>, SelfStudyCheckFactory {
    public func makeView() -> AnyView {
        AnyView(
            NavigationView {
                SelfStudyCheckFeature(
                    store: .init(
                        initialState: SelfStudyCheckReducer.State(),
                        reducer: {
                            SelfStudyCheckReducer()
                        }
                    )
                )
            }
        )
    }
}
