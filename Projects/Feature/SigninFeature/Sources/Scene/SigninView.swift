import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

struct SigninView: View {
    let store: StoreOf<SigninReducer>
    @EnvironmentObject var router: AppRouter
    
    public init(store: StoreOf<SigninReducer>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                emailTextField(viewStore)
                passwordTextField(viewStore)
                forgotPasswordLinkSection
                Spacer()
                signupLinkSection
                signinButton(viewStore)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: viewStore.isSigninSuccessful) { isSuccessful in
                if isSuccessful {
                    router.path = [.home]
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 0) {
                Text("PiCK")
                    .foregroundColor(Color.Primary.primary500)
                Text("에 로그인하기")
            }
            .pickText(type: .heading2)
            
            Text("PiCK 계정으로 로그인 해주세요.")
                .pickText(type: .body1)
        }
        .padding(.top, 80)
        .padding(.leading, 24)
    }
    
    private func emailTextField(_ viewStore: ViewStoreOf<SigninReducer>) -> some View {
        PiCKTextField(
            text: viewStore.binding(
                get: \.email,
                send: SigninReducer.Action.emailChanged
            ),
            placeholder: "학교 이메일을 입력해주세요",
            titleText: "이메일",
            showEmail: true
        )
        .padding(.horizontal, 24)
        .padding(.top, 50)
    }
    
    private func passwordTextField(_ viewStore: ViewStoreOf<SigninReducer>) -> some View {
        PiCKTextField(
            text: viewStore.binding(
                get: \.password,
                send: SigninReducer.Action.passwordChanged
            ),
            placeholder: "비밀번호를 입력해주세요",
            titleText: "비밀번호",
            isSecurity: true
        )
        .padding(.horizontal, 24)
        .padding(.top, 44)
    }

    private var forgotPasswordLinkSection: some View {
        UnderLineButton(
            prefixText: "비밀번호를 잊어버리셨나요? ",
            buttonText: "비밀번호 변경",
            action: {
                router.path.append(.changePassword)
            }
        )
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing, 24)
        .padding(.top, 12)
    }

    private var signupLinkSection: some View {
        UnderLineButton(
            prefixText: "PiCK 계정이 없으세요? ",
            buttonText: "회원가입",
            action: {
                router.path.append(.secretKey)
            }
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
    }

    private func signinButton(_ viewStore: ViewStoreOf<SigninReducer>) -> some View {
        Button {
            viewStore.send(.signinButtonTapped)
        } label: {
            ZStack {
                Text("로그인하기")
                    .pickText(type: .button1, textColor: .Normal.white)
                    .opacity(viewStore.isLoading ? 0 : 1)

                if viewStore.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .white))
                }
            }
            .frame(maxWidth: .infinity)
            .frame(height: 47)
            .background(buttonBackgroundColor(viewStore))
            .cornerRadius(8)
        }
        .disabled(!viewStore.email.isEmpty && !viewStore.password.isEmpty && !viewStore.isLoading ? false : true)
        .padding(.horizontal, 24)
        .padding(.bottom, 28)
    }

    private func buttonBackgroundColor(_ viewStore: ViewStoreOf<SigninReducer>) -> Color {
        let isFormValid = !viewStore.email.isEmpty && !viewStore.password.isEmpty
        return (isFormValid && !viewStore.isLoading) ? .Primary.primary500 : .Primary.primary100
    }
}
