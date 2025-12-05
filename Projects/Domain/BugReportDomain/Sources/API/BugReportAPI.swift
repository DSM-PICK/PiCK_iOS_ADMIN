import Foundation
import BaseDomain
import Moya

public enum BugReportAPI {
    case uploadImage(images: [Data])
    case bugReport(title: String, content: String, fileNames: [String])
}

extension BugReportAPI: PiCKAPI {
    public typealias ErrorType = Never

    public var domain: PiCKDomain {
        .bug
    }

    public var urlPath: String {
        switch self {
        case .uploadImage:
            return "/upload"
        case .bugReport:
            return "/message"
        }
    }

    public var method: Moya.Method {
        .post
    }

    public var task: Moya.Task {
        switch self {
        case .uploadImage(let images):
            var multipartData: [MultipartFormData] = []

            for image in images {
                multipartData.append(.init(
                    provider: .data(image),
                    name: "file",
                    fileName: "file.jpg",
                    mimeType: "image/jpeg"
                ))
            }

            return .uploadMultipart(multipartData)

        case let .bugReport(title, content, fileNames):
            let params: [String: Any] = [
                "title": title,
                "model": "IOS",
                "content": content,
                "file_name": fileNames
            ]
            return .requestParameters(parameters: params, encoding: JSONEncoding.default)
        }
    }

    public var pickHeader: TokenType {
        .accessToken
    }

    public var errorMap: [Int : ErrorType]? {
        nil
    }
}
