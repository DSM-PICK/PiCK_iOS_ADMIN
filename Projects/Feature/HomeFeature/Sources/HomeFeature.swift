import SwiftUI
import ComposableArchitecture

public struct HomeFeature: View {
    let store: Store<HomeReducer.State, HomeReducer.Action>

    public init(store: Store<HomeReducer.State, HomeReducer.Action>) {
        self.store = store
    }

    public var body: some View {
        TabBarView(store: store)
    }
}
