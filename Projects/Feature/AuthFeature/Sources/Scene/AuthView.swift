import SwiftUI
import ComposableArchitecture

struct AuthView: View {
    let store: StoreOf<AuthReducer>

    public init(store: StoreOf<AuthReducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                TextField(
                    "Email",
                    text: viewStore.binding(get: \.email, send: AuthReducer.Action.emailChanged)
                )
                .textFieldStyle(.roundedBorder)
                .padding()

                SecureField(
                    "Password",
                    text: viewStore.binding(get: \.password, send: AuthReducer.Action.passwordChanged)
                )
                .textFieldStyle(.roundedBorder)
                .padding()

                Button("Login") {
                    viewStore.send(.loginButtonTapped)
                }
            }
        }
    }
}
