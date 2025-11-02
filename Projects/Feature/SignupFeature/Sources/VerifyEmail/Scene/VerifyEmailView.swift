import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility
import BaseFeature

struct VerifyEmailView: View {
    let store: StoreOf<VerifyEmailReducer>
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) var dismiss

    public init(store: StoreOf<VerifyEmailReducer>) {
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
                    
                    Text("DSM 이메일로 인증해주세요.")
                        .pickText(type: .body1)
                        .padding(.leading, 24)
                        .padding(.top, 12)

                    PiCKTextField(
                        text: viewStore.binding(
                            get: \.email,
                            send: VerifyEmailReducer.Action.emailChanged
                        ),
                        placeholder: "학교 이메일을 입력해주세요",
                        titleText: "이메일",
                        showVerification: true,
                        verificationButtonTapped: { viewStore.send(.verificationButtonTapped) }
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 50)

                    PiCKTextField(
                        text: viewStore.binding(
                            get: \.code,
                            send: VerifyEmailReducer.Action.codeChanged
                        ),
                        placeholder: "인증 코드를 입력해주세요",
                        titleText: "인증 코드"
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 44)

                    Spacer()

                    PiCKButton(
                        buttonText: "다음",
                        isEnabled: !viewStore.email.isEmpty && !viewStore.code.isEmpty,
                        action: { viewStore.send(.nextButtonTapped) }
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 28)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: viewStore.isSuccessful) { isSuccessful in
                if isSuccessful {
                    router.path.append(.password(
                        secretKey: viewStore.secretKey,
                        accountId: viewStore.email,
                        code: viewStore.code
                    ))
                }
            }
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
