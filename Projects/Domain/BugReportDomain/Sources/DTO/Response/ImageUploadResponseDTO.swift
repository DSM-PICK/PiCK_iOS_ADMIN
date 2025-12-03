import Foundation

public struct ImageUploadResponseDTO: Decodable {
    public let fileNames: [String]

    enum CodingKeys: String, CodingKey {
        case fileNames = "file_name"
    }
}
