import Foundation
import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct ClassroomMoveListView: View {
    let store: StoreOf<ClassroomMoveListReducer>
    @State private var isApplyBottomSheetPresented = false
    
    public init(store: StoreOf<ClassroomMoveListReducer>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 0) {
                    HStack {
                        (Text(verbatim: todayString) + Text(" 교실 이동자"))
                            .pickText(type: .heading4, textColor: .Normal.black)
                            .padding(.leading, 24)

                        Spacer()

                        ClassroomFilterButton(
                            selectedClassroom: viewStore.currentType.displayText,
                            onTap: { isApplyBottomSheetPresented = true }
                        )
                        .padding(.trailing, 24)
                    }
                    .padding(.top, 24)

                    Rectangle()
                        .fill(Color.Gray.gray200)
                        .frame(height: 0.5)
                        .cornerRadius(0.5)
                        .padding(.top, 16)
                        .padding(.horizontal, 24)

                    Spacer()
                }
                .sheet(isPresented: $isApplyBottomSheetPresented) {
                    PiCK_iOS_DesignSystem.SinglePickerBottomSheet(
                        isPresented: $isApplyBottomSheetPresented,
                        title: "필터을 선택해주세요",
                        options: ["층으로", "교실로"],
                        onComplete: { option in
                            let current = typeFromString(option)
                            viewStore.send(.currentTypeChanged(current))
                        }
                    )
                    .presentationDetents([.height(350)])
                    .presentationDragIndicator(.hidden)
                }
                .navigationTitle("교실 이동 현황")
                .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}

extension ClassroomMoveListView {
    private var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일"
        return formatter.string(from: Date())
    }

    private func typeFromString(_ text: String) -> ClassroomMoveListReducer.ClassroomMoveListType {
        switch text {
        case "층으로": return .floor
        case "교실로": return .classroom
        default: return .floor
        }
    }
}
