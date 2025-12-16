import SwiftUI
import ComposableArchitecture

public struct WithDrawFeature: View {
    let store: StoreOf<WithDrawReducer>

    public init(store: StoreOf<WithDrawReducer>) {
        self.store = store
    }

    public var body: some View {
        WithDrawView(store: store)
    }
}
