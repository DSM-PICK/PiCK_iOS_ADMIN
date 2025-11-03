import SwiftUI
import ComposableArchitecture
import PlanDomainInterface

public struct PlanView: View {
    let store: StoreOf<PlanReducer>
    
    public init(store: StoreOf<PlanReducer>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
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
                    .padding(.top, 16)

                    ScheduleListView(
                        selectedDate: viewStore.selectedDate,
                        schedules: viewStore.academicSchedule
                    )
                    .padding(.top, 12)
                    
                    Spacer()
                }
            }
            .background(Color.white)
            .navigationBarTitleDisplayMode(.inline)
            .onAppear {
                let today = Date()
                viewStore.send(.changeMonth(today))
                viewStore.send(.selectDate(today))
            }
        }
    }
}
