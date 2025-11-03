import SwiftUI
import PlanDomainInterface
import PiCK_iOS_DesignSystem

public struct ScheduleListView: View {
    let selectedDate: Date
    let schedules: AcademicScheduleEntity
    
    private let calendar = Calendar.current
    
    public init(
        selectedDate: Date,
        schedules: AcademicScheduleEntity
    ) {
        self.selectedDate = selectedDate
        self.schedules = schedules
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 4) {
                if calendar.isDateInToday(selectedDate) {
                    Text("오늘")
                        .pickText(type: .caption1, textColor: .Primary.primary500)
                    
                    Text(dateText)
                        .pickText(type: .caption1, textColor: .Normal.black)
                } else {
                    Text(dateText)
                        .pickText(type: .caption1, textColor: .Normal.black)
                }
            }
            .padding(.leading, 24)
            
            if schedules.isEmpty {
                Text("일정이 없습니다.")
                    .font(.system(size: 14, weight: .regular))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 72)
            } else {
                Text("\(schedules.count)개의 일정이 있습니다.")
                    .pickText(type: .caption2, textColor: .Gray.gray800)
                    .padding(.leading, 24)
                    .padding(.top, 8)

                VStack(spacing: 0) {
                    ForEach(schedules) { schedule in
                        ScheduleRow(schedule: schedule)
                    }
                }
                .padding(.top, 24)
            }
        }
    }
    
    private var dateText: String {
        let month = calendar.component(.month, from: selectedDate)
        let day = calendar.component(.day, from: selectedDate)
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "E"
        let dayOfWeek = dateFormatter.string(from: selectedDate)
        
        return "\(month)월 \(day)일 \(dayOfWeek)요일"
    }
}

struct ScheduleRow: View {
    let schedule: AcademicScheduleEntityElement
    
    var body: some View {
        HStack(spacing: 0) {
            Rectangle()
                .fill(Color.Primary.primary500)
                .frame(width: 4, height: 51)
            
            Text(schedule.eventName)
                .pickText(type: .subTitle2, textColor: .Normal.black)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.leading, 20)
        }
        .padding(.horizontal, 24)
    }
}
