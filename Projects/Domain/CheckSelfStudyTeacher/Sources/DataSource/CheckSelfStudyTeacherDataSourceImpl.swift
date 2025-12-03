import Foundation
import BaseDomain
import Core
import Moya

public class CheckSelfStudyTeacherDataSourceImpl: CheckSelfStudyTeacherDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<CheckSelfStudyTeacherAPI>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<CheckSelfStudyTeacherAPI>(plugins: [MoyaLoggingPlugin()])
    }

    public func getSelfStudyTeacher(date: String) async throws -> [SelfStudyTeacherResponseDTO] {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.getSelfStudyTeacher(date: date)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map([SelfStudyTeacherResponseDTO].self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = CheckSelfStudyTeacherAPI.getSelfStudyTeacher(date: date).errorMap,
                       let mappedError = errorMap[code] {
                        continuation.resume(throwing: mappedError)
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
}
