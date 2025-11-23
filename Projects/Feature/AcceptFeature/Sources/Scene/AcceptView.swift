import SwiftUI
import PiCK_iOS_DesignSystem

public struct AcceptView: View {
    @State private var isBottomSheetPresented = false
    @State private var selectedOption: ApplyBottomSheet.SelectionOption = .outgoing

    public init() {}

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            AcceptFilterButton(
                selectedOption: selectedOption,
                onTap: { isBottomSheetPresented = true }
            )
            .padding(.top, 24)
            .padding(.leading, 24)

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
