import SwiftUI
import ComposableArchitecture
import PlanDomainInterface
import PiCK_iOS_DesignSystem
import Utility

public struct PlanView: View {
    @Perception.Bindable var store: StoreOf<PlanReducer>
    private let calendar = Calendar.current

    public init(store: StoreOf<PlanReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                VStack(spacing: 0) {
                    MonthHeaderView(
                        currentMonth: store.currentMonth,
                        onMonthChange: { date in
                            store.send(.changeMonth(date))
                        }
                    )
                    .padding(.top, 32)
                    .padding(.horizontal, 20)

                    ScrollView {
                        VStack(spacing: 0) {
                            AcademicScheduleCalendarView(
                                monthSchedule: store.monthAcademicSchedule,
                                selectedDate: store.selectedDate,
                                currentMonth: store.currentMonth,
                                onDateSelect: { date in
                                    store.send(.selectDate(date))
                                },
                                onMonthChange: { date in
                                    store.send(.changeMonth(date))
                                }
                            )
                            .padding(.top, 12)
                            .padding(.horizontal, 24)

                            ScheduleListView(
                                selectedDate: store.selectedDate,
                                schedules: store.academicSchedule
                            )

                            Spacer()
                        }
                    }
                }
                .background(Color.white)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        PiCKImage.pickLogo
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(.leading, 8)
                    }
                }
                .onAppear {
                    store.send(.loadInitialData)
                }
            }
        }
    }
}

struct MonthHeaderView: View {
    let currentMonth: Date
    let onMonthChange: (Date) -> Void
    private let calendar = Calendar.current

    var body: some View {
        HStack(spacing: 0) {
            Button(action: {
                changeMonth(by: -1)
            }) {
                Image(systemName: "chevron.left")
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
            }

            Spacer()
                .frame(width: 12)

            Text(headerText)
                .font(.system(size: 16, weight: .medium))
                .foregroundColor(.black)

            Spacer()
                .frame(width: 12)

            Button(action: {
                changeMonth(by: 1)
            }) {
                Image(systemName: "chevron.right")
                    .foregroundColor(.black)
                    .frame(width: 24, height: 24)
            }
        }
    }

    private var headerText: String {
        return currentMonth.toKoreanYearMonthString()
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            onMonthChange(newMonth)
        }
    }
}
