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

    static let neisBaseURL: URL = URL(string: "https://open.neis.go.kr/hub")!

    static let neisAPIKey: String = Bundle.main.object(forInfoDictionaryKey: "NEIS_API_KEY") as? String ?? ""

    static let neisAtptOfcdcScCode: String = Bundle.main.object(forInfoDictionaryKey: "NEIS_ATPT_OFCDC_SC_CODE") as? String ?? ""

    static let neisSdSchulCode: String = Bundle.main.object(forInfoDictionaryKey: "NEIS_SD_SCHUL_CODE") as? String ?? ""
}
