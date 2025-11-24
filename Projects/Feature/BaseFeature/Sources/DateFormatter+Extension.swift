import Foundation

public extension DateFormatter {
    static let koreanMonthDay: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter
    }()
}

public extension Date {
    var koreanMonthDayString: String {
        DateFormatter.koreanMonthDay.string(from: self)
    }
}
