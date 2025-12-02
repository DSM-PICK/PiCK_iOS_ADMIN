import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import BaseFeature

public struct CheckSelfStudyTeacherView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<CheckSelfStudyTeacherReducer>
    @State private var selectedDate = Date()
    @State private var currentPage = Date()
    @State private var isWeekMode = true

    public init(store: StoreOf<CheckSelfStudyTeacherReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.Gray.gray50
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    Spacer()

                    PiCKCalendarView(
                        calendarType: .selfStudy,
                        selectedDate: $selectedDate,
                        currentPage: $currentPage,
                        isWeekMode: $isWeekMode,
                        dateSelected: { date in
                            print("Selected date: \(date)")
                        }
                    )
                }
                .ignoresSafeArea(edges: .bottom)
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
                    Text("자습 감독 선생님 확인")
                        .pickText(type: .subTitle1, textColor: .Normal.black)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }
}
