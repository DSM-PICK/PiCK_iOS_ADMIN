import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

struct ResignView: View {
    let store: StoreOf<ResignReducer>

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                Text("회원탈퇴")
                    .pickText(type: .heading2)

                Text("회원탈퇴 기능은 준비 중입니다.")
                    .pickText(type: .body1, textColor: .Gray.gray600)

                Spacer()
            }
            .padding()
            .navigationTitle("회원탈퇴")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}
