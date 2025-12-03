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
        HStack(spacing: 0) {
            Text("비밀번호를 잊어버리셨나요? ")
                .foregroundColor(Color.Gray.gray900)
                .pickText(type: .body1)

            Button {
                // TODO: 비밀번호 변경 액션
            } label: {
                Text("비밀번호 변경")
                    .foregroundColor(Color.Primary.primary500)
                    .pickText(type: .body1)
                    .underline()
            }
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .padding(.trailing, 24)
        .padding(.top, 12)
    }

    private var signupLinkSection: some View {
        HStack(spacing: 0) {
            Text("PiCK 계정이 없으세요? ")
                .foregroundColor(Color.Gray.gray900)
                .pickText(type: .body1)

            Button {
                router.path.append(.secretKey)
            } label: {
                Text("회원가입")
                    .foregroundColor(Color.Primary.primary500)
                    .pickText(type: .body1)
                    .underline()
            }
        }
        .padding(.horizontal, 24)
        .padding(.bottom, 12)
    }

    private func signinButton(_ viewStore: ViewStoreOf<SigninReducer>) -> some View {
        PiCKButton(
            buttonText: "로그인하기",
            isEnabled: !viewStore.email.isEmpty && !viewStore.password.isEmpty,
            action: { viewStore.send(.signinButtonTapped) }
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 28)
    }
}
