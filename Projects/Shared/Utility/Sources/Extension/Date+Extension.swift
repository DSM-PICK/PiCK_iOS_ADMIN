import Foundation

public extension Date {
    /// Date를 "yyyy-MM-dd" 형식의 문자열로 변환
    func toString(format: String = "yyyy-MM-dd") -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }
    
    /// 오늘 날짜를 "yyyy-MM-dd" 형식으로 반환
    static func todayString(format: String = "yyyy-MM-dd") -> String {
        return Date().toString(format: format)
    }
    
    /// Date를 "M월 d일 E요일" 형식의 한글 문자열로 변환 (예: "1월 23일 화요일")
    func toKoreanDateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 E요일"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.string(from: self)
    }
}

public extension String {
    /// "yyyy-MM-dd" 형식의 문자열을 Date로 변환
    func toDate(format: String = "yyyy-MM-dd") -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        return formatter.date(from: self)
    }
    
    /// "yyyy-MM-dd" 형식의 문자열을 "M월 d일 E요일" 형식으로 변환
    func toKoreanDateString() -> String? {
        return self.toDate()?.toKoreanDateString()
    }
}
