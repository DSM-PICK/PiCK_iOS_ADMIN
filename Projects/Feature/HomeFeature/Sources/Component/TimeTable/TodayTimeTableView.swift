import SwiftUI

struct TodayTimeTableView: View {
    let schedules: [Schedule]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("오늘의 시간표")
                .font(.system(size: 20, weight: .bold))
                .foregroundColor(.black)
                .padding(.horizontal, 20)
                .padding(.top, 24)
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
        .background(Color.white)
        .cornerRadius(12)
        .shadow(color: Color.black.opacity(0.05), radius: 10, x: 0, y: 2)
    }
}

struct TimeTableRow: View {
    let period: Int
    let subject: String?
    
    var body: some View {
        HStack(spacing: 16) {
            Text("\(period)교시")
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(subject != nil ? Color(red: 0.45, green: 0.47, blue: 1.0) : .gray)
                .frame(width: 60, alignment: .leading)
            
            Text(subject ?? "-")
                .font(.system(size: 16))
                .foregroundColor(subject != nil ? .black : .gray.opacity(0.5))
            
            Spacer()
        }
        .padding(.vertical, 8)
    }
}

struct Schedule: Identifiable {
    let id = UUID()
    let period: Int
    let subject: String
}
