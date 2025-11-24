import Foundation
import BaseDomain
import Core
import Moya

public class AcceptDataSourceImpl: AcceptDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<AcceptAPI>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<AcceptAPI>(plugins: [MoyaLoggingPlugin()])
    }

    public func getApplicationsByGrade(grade: Int, classNum: Int) async throws -> ApplicationListResponseDTO {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.getApplicationsByGrade(grade: grade, classNum: classNum)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map(ApplicationListResponseDTO.self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = AcceptAPI.getApplicationsByGrade(grade: grade, classNum: classNum).errorMap,
                       let mappedError = errorMap[code] {
                        continuation.resume(throwing: mappedError)
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    public func getClassroomMovesByGrade(grade: Int, classNum: Int) async throws -> ClassroomMoveListResponseDTO {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.getClassroomMovesByGrade(grade: grade, classNum: classNum)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map(ClassroomMoveListResponseDTO.self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = AcceptAPI.getClassroomMovesByGrade(grade: grade, classNum: classNum).errorMap,
                       let mappedError = errorMap[code] {
                        continuation.resume(throwing: mappedError)
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    public func updateApplicationStatus(status: String, idList: [String]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.updateApplicationStatus(status: status, idList: idList)) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }

    public func updateClassroomMoveStatus(status: String, idList: [String]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.updateClassroomMoveStatus(status: status, idList: idList)) { result in
                switch result {
                case .success:
                    continuation.resume()
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
