import Foundation

public struct URLUtil {}

public extension URLUtil {
    static let baseURL: URL = {
        guard let urlString = Bundle.main.object(forInfoDictionaryKey: "API_BASE_URL") as? String,
              !urlString.isEmpty,
              let url = URL(string: urlString) else {
            fatalError("API_BASE_URL must be configured in Info.plist")
        }
        return url
    }()
}
