import Foundation
import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct OutListView: View {
    @State private var floorValue = "전체"
    @State private var isApplyBottomSheetPresented = false
    let store: StoreOf<OutListReducer>

    public init(store: StoreOf<OutListReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                HStack {
                    (Text(verbatim: todayString) + Text(" 외출자"))
                    .pickText(type: .heading4, textColor: .Normal.black)
                    .padding(.leading, 24)

                    Spacer()

                    ClassroomFilterButton(
                        selectedClassroom: floorValue,
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

                ScrollView {
                    VStack(spacing: 16) {
                        ForEach (0..<14, id: \.self) { _ in
                            PiCKAcceptStudentCell(
                                studentNumber: "2216",
                                studentName: "하원",
                                startTime: "8교시",
                                endTime: "10교시",
                                activityType: "외출 수락",
                                reason: "집에 가고 싶어요",
                                isSelected: false,
                                onTap: {}
                            )
                        }
                    }
                }
                .padding(.top, 20)
                .padding(.horizontal, 24)

                PiCKButton(
                    buttonText: "복귀 시키기",
                    isEnabled: false,
                    height: 45,
                    action: {}
                )
                .padding(.vertical, 10)
                .padding(.horizontal, 24)
            }
        }
        .sheet(isPresented: $isApplyBottomSheetPresented) {
            PiCK_iOS_DesignSystem.SinglePickerBottomSheet(
                isPresented: $isApplyBottomSheetPresented,
                title: "층을 선택해주세요",
                options: ["전체", "2층", "3층", "4층"],
                onComplete: { option in
                    floorValue = option
                }
            )
            .presentationDetents([.height(350)])
            .presentationDragIndicator(.hidden)
        }
        .navigationTitle("외출자 목록")
        .navigationBarTitleDisplayMode(.inline)
    }
}

extension OutListView {
    private var todayString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "MM월 dd일"
        return formatter.string(from: Date())
    }
}
