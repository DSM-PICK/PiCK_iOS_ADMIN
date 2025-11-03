import SwiftUI
import PlanDomainInterface
import PiCK_iOS_DesignSystem

public struct AcademicScheduleCalendarView: View {
    let monthSchedule: AcademicScheduleEntity
    let selectedDate: Date
    let currentMonth: Date
    let onDateSelect: (Date) -> Void
    let onMonthChange: (Date) -> Void
    
    private let calendar = Calendar.current
    private let daysOfWeek = ["일", "월", "화", "수", "목", "금", "토"]
    
    public init(
        monthSchedule: AcademicScheduleEntity,
        selectedDate: Date,
        currentMonth: Date,
        onDateSelect: @escaping (Date) -> Void,
        onMonthChange: @escaping (Date) -> Void
    ) {
        self.monthSchedule = monthSchedule
        self.selectedDate = selectedDate
        self.currentMonth = currentMonth
        self.onDateSelect = onDateSelect
        self.onMonthChange = onMonthChange
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 24.33) {
                ForEach(daysOfWeek, id: \.self) { day in
                    Text(day)
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.black)
                        .frame(maxWidth: .infinity)
                }
            }
            .padding(.bottom, 16)

            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 24.33), count: 7), spacing: 20) {
                ForEach(calendarDates, id: \.self) { date in
                    if let date = date {
                        DateCell(
                            date: date,
                            isSelected: calendar.isDate(date, inSameDayAs: selectedDate),
                            isToday: calendar.isDateInToday(date),
                            hasEvent: hasEvent(for: date),
                            isCurrentMonth: calendar.isDate(date, equalTo: currentMonth, toGranularity: .month)
                        )
                        .onTapGesture {
                            onDateSelect(date)
                        }
                    } else {
                        Color.clear
                            .frame(height: 40)
                    }
                }
            }
        }
        .padding()
    }
    
    private var calendarDates: [Date?] {
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: currentMonth))!
        let range = calendar.range(of: .day, in: .month, for: startOfMonth)!
        
        var dates: [Date?] = []
        
        let firstWeekday = calendar.component(.weekday, from: startOfMonth)
        for _ in 0..<(firstWeekday - 1) {
            dates.append(nil)
        }
        
        for day in range {
            if let date = calendar.date(byAdding: .day, value: day - 1, to: startOfMonth) {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    private func hasEvent(for date: Date) -> Bool {
        let month = calendar.component(.month, from: date)
        let day = calendar.component(.day, from: date)
        
        return monthSchedule.contains { schedule in
            schedule.month == month && schedule.day == day
        }
    }
    
    private func changeMonth(by value: Int) {
        if let newMonth = calendar.date(byAdding: .month, value: value, to: currentMonth) {
            onMonthChange(newMonth)
        }
    }
}
