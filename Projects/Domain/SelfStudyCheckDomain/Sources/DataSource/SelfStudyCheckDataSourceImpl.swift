import Foundation
import BaseDomain
import Core
import Moya
import SelfStudyCheckDomainInterface

public final class SelfStudyCheckDataSourceImpl: SelfStudyCheckDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<SelfStudyCheckAPI>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<SelfStudyCheckAPI>(plugins: [MoyaLoggingPlugin()])
    }

    public func getStudentAttendance(grade: Int, classNum: Int, period: Int) async throws -> [StudentAttendanceResponseDTO] {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.getStudentAttendance(grade: grade, classNum: classNum, period: period)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map([StudentAttendanceResponseDTO].self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = SelfStudyCheckAPI.getStudentAttendance(grade: grade, classNum: classNum, period: period).errorMap,
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
