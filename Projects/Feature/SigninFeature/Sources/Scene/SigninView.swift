import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

struct SigninView: View {
    let store: StoreOf<SigninReducer>

    public init(store: StoreOf<SigninReducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                TextField(
                    "Email",
                    text: viewStore.binding(get: \.email, send: SigninReducer.Action.emailChanged)
                )
                .textFieldStyle(.roundedBorder)
                .padding()

                SecureField(
                    "Password",
                    text: viewStore.binding(get: \.password, send: SigninReducer.Action.passwordChanged)
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
