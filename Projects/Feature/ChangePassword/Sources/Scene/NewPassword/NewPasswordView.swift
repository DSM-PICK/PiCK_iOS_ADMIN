import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

public struct NewPasswordView: View {
    let store: StoreOf<NewPasswordReducer>
    let onSuccess: () -> Void
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var router: AppRouter
    @State private var showSuccessAlert = false
    @State private var dismissCount = 0

    public init(
        store: StoreOf<NewPasswordReducer>,
        onSuccess: @escaping () -> Void = {}
    ) {
        self.store = store
        self.onSuccess = onSuccess
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                headerSection
                newPasswordTextField(viewStore)
                newPasswordCheckTextField(viewStore)

                if let errorMessage = viewStore.errorMessage {
                    Text(errorMessage)
                        .pickText(type: .body1, textColor: .Error.error)
                        .padding(.horizontal, 24)
                        .padding(.top, 8)
                }

                Spacer()
                changeButton(viewStore)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: viewStore.isChangeSuccessful) { isSuccessful in
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
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.black)
                    }
                }
            }
            .alert("비밀번호 변경 완료", isPresented: $showSuccessAlert) {
                Button("확인", role: .cancel) {
                    // router.path에 changePassword가 있으면 로그인 뷰에서 온 것
                    if let changePasswordIndex = router.path.firstIndex(where: { route in
                        if case .changePassword = route { return true }
                        return false
                    }) {
                        router.path.removeSubrange(changePasswordIndex...)
                    } else {
                        // 전체 탭에서 온 경우 - dismiss를 두 번 호출
                        dismiss()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            dismiss()
                        }
                    }
                }
            } message: {
                Text("비밀번호가 성공적으로 변경되었습니다.")
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

    private func newPasswordTextField(_ viewStore: ViewStoreOf<NewPasswordReducer>) -> some View {
        PiCKTextField(
            text: viewStore.binding(
                get: \.newPassword,
                send: NewPasswordReducer.Action.newPasswordChanged
            ),
            placeholder: "비밀번호를 입력해주세요",
            titleText: "새로운 비밀번호",
            isSecurity: true
        )
        .padding(.horizontal, 24)
        .padding(.top, 75)
    }

    private func newPasswordCheckTextField(_ viewStore: ViewStoreOf<NewPasswordReducer>) -> some View {
        PiCKTextField(
            text: viewStore.binding(
                get: \.newPasswordCheck,
                send: NewPasswordReducer.Action.newPasswordCheckChanged
            ),
            placeholder: "비밀번호를 입력해주세요",
            titleText: "새로운 비밀번호 확인",
            isSecurity: true
        )
        .padding(.horizontal, 24)
        .padding(.top, 44)
    }

    private func changeButton(_ viewStore: ViewStoreOf<NewPasswordReducer>) -> some View {
        PiCKButton(
            buttonText: "변경",
            isEnabled: !viewStore.newPassword.isEmpty && !viewStore.newPasswordCheck.isEmpty,
            action: { viewStore.send(.changeButtonTapped) }
        )
        .padding(.horizontal, 24)
        .padding(.bottom, 28)
    }
}
