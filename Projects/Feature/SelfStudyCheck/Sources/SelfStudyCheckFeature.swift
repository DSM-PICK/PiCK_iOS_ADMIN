import SwiftUI
import ComposableArchitecture

public struct SelfStudyCheckFeature: View {
    let store: Store<SelfStudyCheckReducer.State, SelfStudyCheckReducer.Action>

    public init(
        store: Store<SelfStudyCheckReducer.State, SelfStudyCheckReducer.Action>
    ) {
        self.store = store
    }

    public var body: some View {
        SelfStudyCheckView(store: store)
    }
}
