import SwiftUI
import HomeFeature
import ComposableArchitecture
import PlanDomainInterface
import PiCK_iOS_DesignSystem

public struct PlanView: View {
    let store: StoreOf<PlanReducer>
    private let calendar = Calendar.current
    
    public init(store: StoreOf<PlanReducer>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack {
                VStack(spacing: 0) {
                    MonthHeaderView(
                        currentMonth: viewStore.currentMonth,
                        onMonthChange: { date in
                            viewStore.send(.changeMonth(date))
                        }
                    )
                        .padding(.top, 32)
                        .padding(.horizontal, 20)
                    
                    ScrollView {
                        VStack(spacing: 0) {
                            AcademicScheduleCalendarView(
                                monthSchedule: viewStore.monthAcademicSchedule,
                                selectedDate: viewStore.selectedDate,
                                currentMonth: viewStore.currentMonth,
                                onDateSelect: { date in
                                    viewStore.send(.selectDate(date))
                                },
                                onMonthChange: { date in
                                    viewStore.send(.changeMonth(date))
                                }
                            )
                            .padding(.top, 12)

                            ScheduleListView(
                                selectedDate: viewStore.selectedDate,
                                schedules: viewStore.academicSchedule
                            )
                            
                            Spacer()
                        }
                    }
                }
                .background(Color.white)
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        PiCKNavigationBar()
                            .padding(.leading, 8)
                    }
                }
                .onAppear {
                    let today = Date()
                    viewStore.send(.changeMonth(today))
                    viewStore.send(.selectDate(today))
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
        let year = calendar.component(.year, from: currentMonth)
        let month = calendar.component(.month, from: currentMonth)
        return "\(year)년 \(month)월"
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            onMonthChange(newMonth)
        }
    }
}
