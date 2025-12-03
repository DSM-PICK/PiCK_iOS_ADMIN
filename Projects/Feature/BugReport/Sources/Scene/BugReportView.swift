import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture

public struct BugReportView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<BugReportReducer>

    public init(store: StoreOf<BugReportReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.Background.background
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    Text("어디서 버그가 발생했나요?")
                        .pickText(type: .heading4, textColor: .Normal.black)
                        .padding(.top, 32)
                        .padding(.horizontal, 24)

                    TextField("", text: viewStore.binding(
                        get: \.bugLocation,
                        send: { .bugLocationChanged($0) }
                    ))
                    .padding()
                    .background(Color.Background.background)
                    .cornerRadius(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.Gray.gray300, lineWidth: 1)
                    )
                    .padding(.top, 16)
                    .padding(.horizontal, 24)

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.Normal.black)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("버그 제보")
                        .pickText(type: .subTitle1, textColor: .Normal.black)
                }
            }
        }
    }
}
