import SwiftUI
import ComposableArchitecture

public struct AllTabFeature: View {
    let store: Store<AllTabReducer.State, AllTabReducer.Action>

    public init(store: Store<AllTabReducer.State, AllTabReducer.Action>) {
        self.store = store
    }

    public var body: some View {
        AllTabView(store: store)
    }
}
