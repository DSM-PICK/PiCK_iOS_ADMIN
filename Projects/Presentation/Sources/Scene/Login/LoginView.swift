
import SwiftUI

import ComposableArchitecture

import DesignSystem

public struct LoginView: View {
    
    @Bindable var store: StoreOf<LoginFeature>
    
    public init(store: StoreOf<LoginFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("PiCK에 로그인하기")
                .font(.pick(.heading2))
                .foregroundStyle(.modeBlack)
                .padding(.bottom, 12)
            
            Text("PiCK 계정으로 로그인 해주세요.")
                .font(.pick(.body1))
                .foregroundStyle(.gray600)
                .padding(.bottom, 75)
            
            PiCKTextField(
                "아이디",
                text: $store.id.sending(\.updateID),
                placeholder: "아이디를 입력해주세요",
                errorMessage: store.idErrorDescription
            )
            .padding(.bottom, 71)
            
            PiCKTextField(
                "비밀번호",
                text: $store.password.sending(\.updatePassword),
                placeholder: "비밀번호를 입력해주세요",
                errorMessage: store.passwordErrorDescription,
                isSecure: true
            )
            
            Spacer()
            
            HStack(spacing: 4) {
                Text("PiCK 계정이 없으신가요?")
                    .font(.pick(.body1))
                    .foregroundStyle(.gray900)
                
                Button(action: {
                    store.send(.signUpButtonDidTap)
                }, label: {
                    Text("회원가입")
                        .underline()
                        .font(.pick(.body1))
                        .foregroundStyle(.gray900)
                })
            }
            .padding(.bottom, 12)
            
            PiCKButton(
                "로그인하기",
                action: {
                    store.send(.loginButtonDidTap)
                }
            )
            .disabled(store.isButtonEnabled)
        }
        .padding(.horizontal, 24)
        .navigationBarBackButtonHidden()
    }
}
