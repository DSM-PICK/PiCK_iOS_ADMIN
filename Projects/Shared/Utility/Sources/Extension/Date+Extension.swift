import Foundation

public extension Date {
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }

    static func todayString(format: String = "yyyy-MM-dd") -> String {
        return Date().toString(format: format)
    }

    func toKoreanDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 E요일"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }

    func toKoreanYearMonthString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }
}

public extension String {
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.date(from: self)
    }

    func toKoreanDateString() -> String? {
        return self.toDate()?.toKoreanDateString()
    }
}
