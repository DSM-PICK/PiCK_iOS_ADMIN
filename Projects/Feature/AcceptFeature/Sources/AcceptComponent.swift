import NeedleFoundation
import SwiftUI
import AcceptFeatureInterface
import ComposableArchitecture
import AcceptDomainInterface

public protocol AcceptDependency: NeedleFoundation.Dependency {
    var getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol { get }
}

public final class AcceptComponent: Component<AcceptDependency>, AcceptFactory {
    public func makeView() -> AnyView {
        AnyView(
            NavigationView {
                AcceptView(
                    store: .init(
                        initialState: AcceptReducer.State(),
                        reducer: {
                            AcceptReducer(
                                getAllApplicationsUseCase: self.dependency.getAllApplicationsUseCase
                            )
                        }
                    )
                )
            }
        )
    }
}
