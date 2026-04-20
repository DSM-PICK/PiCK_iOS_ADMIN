import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility
import BaseFeature

struct VerifyEmailView: View {
    @Perception.Bindable var store: StoreOf<VerifyEmailReducer>
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) var dismiss

    public init(store: StoreOf<VerifyEmailReducer>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
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
                        text: $store.email,
                        placeholder: "학교 이메일을 입력해주세요",
                        titleText: "이메일",
                        showVerification: true,
                        verificationButtonTapped: { store.send(.verificationButtonTapped) }
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 50)

                    PiCKTextField(
                        text: $store.code,
                        placeholder: "인증 코드를 입력해주세요",
                        titleText: "인증 코드"
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 44)

                    Spacer()

                    PiCKButton(
                        buttonText: "다음",
                        isEnabled: !store.email.isEmpty && !store.code.isEmpty,
                        action: { store.send(.nextButtonTapped) }
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 28)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: store.isSuccessful) { isSuccessful in
                if isSuccessful {
                    router.path.append(.password(
                        secretKey: store.secretKey,
                        accountId: store.email,
                        code: store.code
                    ))
                }
            }
            .errorToast(
                message: store.errorMessage ?? "에러발생!",
                isPresented: Binding(
                    get: { store.errorMessage != nil },
                    set: { isPresented in
                        if !isPresented {
                            store.send(.clearError)
                        }
                    }
                )
            )
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: { router.pop() },
                        label: {
                        PiCKImage.leftArrow
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.Normal.black)
                        }
                    )
                }
            }

        }
    }
}
