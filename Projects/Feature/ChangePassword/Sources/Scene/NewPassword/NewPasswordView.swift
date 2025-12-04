import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

public struct NewPasswordView: View {
    let store: StoreOf<NewPasswordReducer>
    @EnvironmentObject var router: AppRouter

    public init(store: StoreOf<NewPasswordReducer>) {
        self.store = store
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
                    router.path = [.signin]
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
