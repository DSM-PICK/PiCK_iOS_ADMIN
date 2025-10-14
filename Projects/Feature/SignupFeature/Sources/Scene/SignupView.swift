import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

struct SignupView: View {
    let store: StoreOf<SignupReducer>

    public init(store: StoreOf<SignupReducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                TextField(
                    "Email",
                    text: viewStore.binding(get: \.email, send: SignupReducer.Action.emailChanged)
                )
                .textFieldStyle(.roundedBorder)
                .padding()

                SecureField(
                    "Password",
                    text: viewStore.binding(get: \.password, send: SignupReducer.Action.passwordChanged)
                )
                .textFieldStyle(.roundedBorder)
                .padding()

                Button("Signup") {
                    viewStore.send(.signupButtonTapped)
                }
            }
        }
    }
}
