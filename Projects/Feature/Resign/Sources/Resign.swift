import SwiftUI
import ComposableArchitecture

public struct ResignFeature: View {
    let store: StoreOf<ResignReducer>

    public init(store: StoreOf<ResignReducer>) {
        self.store = store
    }

    public var body: some View {
        ResignView(store: store)
    }
}
