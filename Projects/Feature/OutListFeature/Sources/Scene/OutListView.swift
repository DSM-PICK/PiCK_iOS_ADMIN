import Foundation
import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct OutListView: View {
    @State private var firstValue = "전체"
    @State private var secondValue = "전체"
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
                        selectedClassroom: "\(firstValue)-\(secondValue)",
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
        }
        .sheet(isPresented: $isApplyBottomSheetPresented) {
            GeometryReader { geometry in
                ZStack(alignment: .bottom) {
                    Color.black.opacity(0.4)
                        .ignoresSafeArea()
                        .onTapGesture {
                            isApplyBottomSheetPresented = false
                        }
                    
                    DualPickerBottomSheet(
                        isPresented: $isApplyBottomSheetPresented,
                        firstValue: $firstValue,
                        secondValue: $secondValue,
                        title: "선택",
                        firstLabel: "학년",
                        secondLabel: "반",
                        firstOptions: ["전체", "1", "2", "3"],
                        secondOptions: ["전체", "1", "2", "3", "4"],
                        onComplete: { first, second in
                            if first == "전체" || second == "전체" {
                                firstValue = "전체"
                                secondValue = "전체"
                            } else {
                                firstValue = first
                                secondValue = second
                            }
                        }
                    )
                    .frame(height: geometry.size.height * 0.5)
                    .transition(.move(edge: .bottom))
                }
                .ignoresSafeArea()
            }
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
