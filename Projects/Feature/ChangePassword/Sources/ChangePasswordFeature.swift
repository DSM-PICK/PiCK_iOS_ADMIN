import SwiftUI
import ComposableArchitecture

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
    let onSuccess: () -> Void

    public init(
        store: StoreOf<NewPasswordReducer>,
        onSuccess: @escaping () -> Void = {}
    ) {
        self.store = store
        self.onSuccess = onSuccess
    }

    public var body: some View {
        NewPasswordView(store: store, onSuccess: onSuccess)
    }
}
