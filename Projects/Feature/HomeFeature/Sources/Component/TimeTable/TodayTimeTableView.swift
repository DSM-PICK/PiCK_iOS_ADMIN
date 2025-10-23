import SwiftUI
import PiCK_iOS_DesignSystem

public struct TodayTimeTableView: View {
    let schedules: [Schedule]
    
    public init(schedules: [Schedule]) {
        self.schedules = schedules
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("오늘의 시간표")
                .pickText(type: .label1)
                .foregroundColor(.black)
                .padding(.top, 24)
                .padding(.horizontal, 20)
                .padding(.bottom, 16)
            
            VStack(spacing: 12) {
                ForEach(1...7, id: \.self) { period in
                    TimeTableRow(
                        period: period,
                        subject: schedules.first(where: { $0.period == period })?.subject
                    )
                }
            }
            .padding(.horizontal, 20)
            .padding(.bottom, 24)
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .cornerRadius(12)
    }
}

struct TimeTableRow: View {
    let period: Int
    let subject: String?
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(period)교시")
                .pickText(type: .subTitle2, textColor: Color.Primary.primary500)
                .frame(width: 60, alignment: .leading)

            Text(subject ?? "-")
                .pickText(type: .label1, textColor: Color.Normal.black)
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

public struct Schedule: Identifiable {
    public let id = UUID()
    public let period: Int
    public let subject: String
    
    public init(period: Int, subject: String) {
        self.period = period
        self.subject = subject
    }
}
