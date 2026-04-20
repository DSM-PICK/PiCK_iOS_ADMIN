import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

public struct NewPasswordView: View {
    @Perception.Bindable var store: StoreOf<NewPasswordReducer>
    let onSuccess: () -> Void
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: AppRouter
    @State private var showSuccessAlert = false

    public init(
        store: StoreOf<NewPasswordReducer>,
        onSuccess: @escaping () -> Void = {}
    ) {
        self.store = store
        self.onSuccess = onSuccess
    }

    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                VStack(alignment: .leading, spacing: 0) {
                    headerSection
                    newPasswordTextField
                    newPasswordCheckTextField

                    if let errorMessage = store.errorMessage {
                        Text(errorMessage)
                            .pickText(type: .body1, textColor: .Error.error)
                            .padding(.horizontal, 24)
                            .padding(.top, 8)
                    }

                    Spacer()
                    changeButton
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .onChange(of: store.isChangeSuccessful) { isSuccessful in
                    if isSuccessful {
                        showSuccessAlert = true
                    }
                }
                .navigationBarBackButtonHidden(true)
                .navigationBarTitleDisplayMode(.inline)
                .navigationTitle("비밀번호 변경")
                .toolbar(.hidden, for: .tabBar)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button(
                            action: {
                                dismiss()
                            },
                            label: {
                                Image(systemName: "chevron.left")
                                    .foregroundColor(.black)
                            }
                        )
                    }
                }

                if showSuccessAlert {
                    PiCKDisappearAlert(
                        successType: .success,
                        message: "비밀번호가 성공적으로 변경되었습니다."
                    )
                    .onDisappear {
                        showSuccessAlert = false
                        if let changePasswordIndex = router.path.firstIndex(where: { route in
                            if case .changePassword = route { return true }
                            return false
                        }) {
                            router.path.removeSubrange(changePasswordIndex...)
                        } else {
                            dismiss()
                            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                                dismiss()
                            }
                        }
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
                Text(" 비밀번호 변경하기")
            }
            .pickText(type: .heading2)

            Text("새로운 비밀번호를 입력해주세요.")
                .pickText(type: .body1, textColor: .Gray.gray600)
        }
        .padding(.top, 58)
        .padding(.leading, 24)
    }

    private var newPasswordTextField: some View {
        PiCKTextField(
            text: $store.newPassword,
            placeholder: "비밀번호를 입력해주세요",
            titleText: "새로운 비밀번호",
            isSecurity: true
        )
        .padding(.horizontal, 24)
        .padding(.top, 75)
    }

    private var newPasswordCheckTextField: some View {
        PiCKTextField(
            text: $store.newPasswordCheck,
            placeholder: "비밀번호를 입력해주세요",
            titleText: "새로운 비밀번호 확인",
            isSecurity: true
        )
        .padding(.horizontal, 24)
        .padding(.top, 44)
    }

    private var changeButton: some View {
        PiCKButton(
            buttonText: "변경",
            isEnabled: !store.newPassword.isEmpty && !store.newPasswordCheck.isEmpty,
            action: { store.send(.changeButtonTapped) }
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 28)
    }
}
