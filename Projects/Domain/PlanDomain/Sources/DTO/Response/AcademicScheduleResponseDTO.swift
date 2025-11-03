import Foundation

public struct AcademicScheduleResponseDTO: Decodable {
    public let id: String
    public let eventName: String
    public let month: Int
    public let day: Int
    public let dayName: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case eventName = "event_name"
        case month
        case day
        case dayName = "day_name"
    }
}

public typealias AcademicScheduleResponseDTOArray = [AcademicScheduleResponseDTO]
