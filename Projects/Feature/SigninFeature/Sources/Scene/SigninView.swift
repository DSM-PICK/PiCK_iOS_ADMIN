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
            VStack(alignment: .leading, spacing: 0) {
                HStack(spacing: 0) {
                    Text("PiCK")
                        .foregroundColor(Color.Primary.primary500)
                    Text("에 로그인하기")
                }
                .pickText(type: .heading2)
                .padding(.top, 80)
                .padding(.leading, 24)
                
                Text("PiCK 계정으로 로그인 해주세요.")
                    .pickText(type: .body1)
                    .padding(.leading, 24)
                    .padding(.top, 12)
                
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
                
                Spacer()
                
                PiCKButton(
                    buttonText: "로그인하기",
                    isEnabled: !viewStore.email.isEmpty && !viewStore.password.isEmpty,
                    action: { viewStore.send(.loginButtonTapped) }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
}
