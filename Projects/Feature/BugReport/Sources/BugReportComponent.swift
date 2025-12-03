import NeedleFoundation
import SwiftUI
import BugReportFeatureInterface
import ComposableArchitecture

public protocol BugReportDependency: NeedleFoundation.Dependency {
}

public final class BugReportComponent: Component<BugReportDependency>, BugReportFactory {
    public func makeView() -> AnyView {
        AnyView(
            BugReportFeature(
                store: .init(
                    initialState: BugReportReducer.State(),
                    reducer: {
                        BugReportReducer()
                    }
                )
            )
        )
    }
}
