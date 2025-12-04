import SwiftUI
import ComposableArchitecture

@_exported import ChangePasswordFeatureInterface

public struct ChangePasswordFeature: View {
    let store: StoreOf<ChangePasswordReducer>

    public init(store: StoreOf<ChangePasswordReducer>) {
        self.store = store
    }

    public var body: some View {
        ChangePasswordView(store: store)
    }
}

public struct NewPasswordFeature: View {
    let store: StoreOf<NewPasswordReducer>

    public init(store: StoreOf<NewPasswordReducer>) {
        self.store = store
    }

    public var body: some View {
        NewPasswordView(store: store)
    }
}
