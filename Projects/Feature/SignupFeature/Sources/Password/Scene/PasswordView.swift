import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility
import BaseFeature

struct PasswordView: View {
    let store: StoreOf<PasswordReducer>
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) var dismiss

    public init(store: StoreOf<PasswordReducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            BaseView {
                VStack(alignment: .leading, spacing: 0) {
                    
                    HStack(spacing: 0) {
                        Text("PiCK")
                            .foregroundColor(Color.Primary.primary500)
                        Text("에 회원가입하기")
                    }
                    .pickText(type: .heading2)
                    .padding(.top, 60)
                    .padding(.leading, 24)
                    
                    Text("사용할 비밀번호를 입력해주세요.")
                        .pickText(type: .body1)
                        .padding(.leading, 24)
                        .padding(.top, 12)

                    PiCKTextField(
                        text: viewStore.binding(
                            get: \.password,
                            send: PasswordReducer.Action.passwordChanged
                        ),
                        placeholder: "8~30자 영문자, 숫자, 특수문자 포함하세요",
                        titleText: "비밀번호",
                        isSecurity: true
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 50)

                    PiCKTextField(
                        text: viewStore.binding(
                            get: \.passwordConfirm,
                            send: PasswordReducer.Action.passwordConfirmChanged
                        ),
                        placeholder: "위에 입력한 비밀번호를 다시 입력해주세요",
                        titleText: "비밀번호 확인",
                        isSecurity: true
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 44)

                    Spacer()

                    PiCKButton(
                        buttonText: "다음",
                        isEnabled: !viewStore.password.isEmpty && !viewStore.passwordConfirm.isEmpty,
                        action: { viewStore.send(.nextButtonTapped) }
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 28)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .errorToast(
                    message: viewStore.errorMessage ?? "에러발생!",
                    isPresented: viewStore.binding(
                        get: { $0.errorMessage != nil },
                        send: .clearError
                    )
                )
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(action: { router.pop() }) {
                            PiCKImage.leftArrow
                                .resizable()
                                .frame(width: 32, height: 32)
                                .foregroundColor(.Normal.black)
                        }
                    }
                }

            }
        }
    }
}
