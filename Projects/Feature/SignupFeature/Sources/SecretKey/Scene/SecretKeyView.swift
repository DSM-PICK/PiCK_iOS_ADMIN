import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility
import BaseFeature

struct SecretKeyView: View {
    let store: StoreOf<SecretKeyReducer>
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) var dismiss

    public init(store: StoreOf<SecretKeyReducer>) {
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
                    
                    Text("PiCK Admin의 시크릿 키를 입력해주세요.")
                        .pickText(type: .body1)
                        .padding(.leading, 24)
                        .padding(.top, 12)
                    
                    PiCKTextField(
                        text: viewStore.binding(
                            get: \.secretKey,
                            send: SecretKeyReducer.Action.secretKeyChanged
                        ),
                        placeholder: "시크릿 키를 입력해주세요",
                        titleText: "시크릿 키"
                    )
                    .padding(.horizontal, 24)
                    .padding(.top, 50)
                    
                    Spacer()
                    
                    PiCKButton(
                        buttonText: "다음",
                        isEnabled: !viewStore.secretKey.isEmpty,
                        action: { viewStore.send(.nextButtonTapped) }
                    )
                    .padding(.horizontal, 24)
                    .padding(.bottom, 28)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .onChange(of: viewStore.isSigninSuccessful) { isSuccessful in
                if isSuccessful {
                    router.path.append(.email(secretKey: viewStore.secretKey))
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
