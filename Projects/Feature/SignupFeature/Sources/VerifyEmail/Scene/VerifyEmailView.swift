import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

struct VerifyEmailView: View {
    let store: StoreOf<VerifyEmailReducer>
    @Environment(\.dismiss) var dismiss
    
    public init(store: StoreOf<VerifyEmailReducer>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                    dismiss()
                }) {
                    PiCKImage.leftArrow
                        .resizable()
                        .frame(width: 32, height: 32)
                }
                .padding([.top, .leading], 20)
                .foregroundColor(.Normal.black)
                Text("시크릿 키: \(viewStore.secretKey)")
            }
        }
    }
}
