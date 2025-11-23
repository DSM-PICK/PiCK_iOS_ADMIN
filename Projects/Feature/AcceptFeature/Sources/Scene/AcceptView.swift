import SwiftUI
import PiCK_iOS_DesignSystem

public struct AcceptView: View {
    @State private var isBottomSheetPresented = false
    @State private var selectedOption: ApplyBottomSheet.SelectionOption = .outgoing

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                HStack(spacing: 16) {
                    AcceptFilterButton(
                        selectedOption: selectedOption,
                        onTap: { isBottomSheetPresented = true }
                    )

                    Text("0월 0일")
                        .pickText(type: .body2, textColor: .Gray.gray700)
                }
                .padding(.leading, 24)

                Spacer()

                AcceptActionButtons(
                    onAccept: {
                        // 수락 액션
                    },
                    onReject: {
                        // 거절 액션
                    }
                )
                .padding(.trailing, 24)
            }
            .padding(.top, 24)

            Rectangle()
                .fill(Color.Gray.gray200)
                .frame(height: 0.5)
                .cornerRadius(0.5)
                .padding(.top, 20)
                .padding(.horizontal, 24)

            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                PiCKNavigationBar()
                    .padding(.leading, 8)
            }
        }
        .sheet(isPresented: $isBottomSheetPresented) {
            ApplyBottomSheet(isPresented: $isBottomSheetPresented) { option in
                selectedOption = option
            }
            .presentationDetents([.height(UIScreen.main.bounds.height * 0.5)])
            .presentationDragIndicator(.hidden)
        }
    }
}
