import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

public struct ChangePasswordView: View {
    let store: StoreOf<ChangePasswordReducer>
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: AppRouter

    public init(store: StoreOf<ChangePasswordReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                emailTextField
                codeTextField

                if let errorMessage = store.errorMessage {
                    Text(errorMessage)
                        .pickText(type: .body1, textColor: .Error.error)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                }

                Spacer()
                nextButton
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: store.accountId) { accountId in
                if let accountId = accountId, !store.code.isEmpty {
                    router.path.append(.newPassword(accountId: accountId, code: store.code))
                }
            }
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .navigationTitle("비밀번호 변경")
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
            .overlay(alignment: .top) {
                if let successMessage = store.successMessage {
                    VStack {
                        HStack(spacing: 8) {
                            Image(systemName: "checkmark.circle.fill")
                                .foregroundColor(.white)
                            Text(successMessage)
                                .pickText(type: .body1, textColor: .Normal.white)
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        .background(Color.Primary.primary500)
                        .cornerRadius(8)
                        .padding(.top, 60)
                    }
                    .transition(.move(edge: .top).combined(with: .opacity))
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            store.send(.clearSuccessMessage)
                        }
                    }
                }
            }
            .animation(.spring(), value: store.successMessage)
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

    private var emailTextField: some View {
        PiCKTextField(
            text: Binding(
                get: { store.email },
                set: { store.send(.emailChanged($0)) }
            ),
            placeholder: "학교 이메일을 입력해주세요",
            titleText: "이메일",
            showVerification: true,
            verificationButtonTapped: {
                store.send(.verificationButtonTapped)
            }
        )
        .padding(.horizontal, 24)
        .padding(.top, 50)
    }

    private var codeTextField: some View {
        PiCKTextField(
            text: Binding(
                get: { store.code },
                set: { store.send(.codeChanged($0)) }
            ),
            placeholder: "인증 코드를 입력해주세요",
            titleText: "인증 코드"
        )
        .padding(.horizontal, 24)
        .padding(.top, 44)
    }

    private var nextButton: some View {
        PiCKButton(
            buttonText: "다음",
            isEnabled: !store.email.isEmpty && !store.code.isEmpty,
            action: { store.send(.nextButtonTapped) }
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 28)
    }
}
