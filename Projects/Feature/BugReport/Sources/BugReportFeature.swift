import SwiftUI
import ComposableArchitecture

public struct BugReportFeature: View {
    let store: Store<BugReportReducer.State, BugReportReducer.Action>

    public init(
        store: Store<BugReportReducer.State, BugReportReducer.Action>
    ) {
        self.store = store
    }

    public var body: some View {
        BugReportView(store: store)
    }
}
