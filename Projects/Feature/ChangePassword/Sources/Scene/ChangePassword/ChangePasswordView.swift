import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

public struct ChangePasswordView: View {
    let store: StoreOf<ChangePasswordReducer>
    @EnvironmentObject var router: AppRouter

    public init(store: StoreOf<ChangePasswordReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                emailTextField(viewStore)
                codeTextField(viewStore)

                if let errorMessage = viewStore.errorMessage {
                    Text(errorMessage)
                        .pickText(type: .body1, textColor: .Error.error)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                }

                Spacer()
                nextButton(viewStore)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: viewStore.accountId) { accountId in
                if let accountId = accountId, !viewStore.code.isEmpty {
                    router.path.append(.newPassword(accountId: accountId, code: viewStore.code))
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("비밀번호 변경")
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        router.pop()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 0) {
                Text("PiCK")
                    .foregroundColor(Color.Primary.primary500)
                Text("에 인증하기")
            }
            .pickText(type: .heading2)

            Text("DSM 이메일로 인증 해주세요.")
                .pickText(type: .body1, textColor: .Gray.gray600)
        }
        .padding(.top, 58)
        .padding(.leading, 24)
    }

    private func emailTextField(_ viewStore: ViewStoreOf<ChangePasswordReducer>) -> some View {
        PiCKTextField(
            text: viewStore.binding(
                get: \.email,
                send: ChangePasswordReducer.Action.emailChanged
            ),
            placeholder: "학교 이메일을 입력해주세요",
            titleText: "이메일",
            showVerification: true,
            verificationButtonTapped: {
                viewStore.send(.verificationButtonTapped)
            }
        )
        .padding(.horizontal, 24)
        .padding(.top, 75)
    }

    private func codeTextField(_ viewStore: ViewStoreOf<ChangePasswordReducer>) -> some View {
        PiCKTextField(
            text: viewStore.binding(
                get: \.code,
                send: ChangePasswordReducer.Action.codeChanged
            ),
            placeholder: "인증 코드를 입력해주세요",
            titleText: "인증 코드"
        )
        .padding(.horizontal, 24)
        .padding(.top, 44)
    }

    private func nextButton(_ viewStore: ViewStoreOf<ChangePasswordReducer>) -> some View {
        PiCKButton(
            buttonText: "다음",
            isEnabled: !viewStore.email.isEmpty && !viewStore.code.isEmpty,
            action: { viewStore.send(.nextButtonTapped) }
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 28)
    }
}
