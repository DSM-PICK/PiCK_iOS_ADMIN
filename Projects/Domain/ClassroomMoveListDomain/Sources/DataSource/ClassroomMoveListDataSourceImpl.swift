import Foundation
import BaseDomain
import Core
import Moya
import ClassroomMoveListDomainInterface

public final class ClassroomMoveListDataSourceImpl: ClassroomMoveListDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<ClassroomMoveListAPI>
    
    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<ClassroomMoveListAPI>(plugins: [MoyaLoggingPlugin()])
    }

    public func getClassroomMoveByFloor(floor: Int) async throws -> [ClassroomMoveListResponseDTO] {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.getClassroomMoveByFloor(floor: floor)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map([ClassroomMoveListResponseDTO].self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = ClassroomMoveListAPI.getClassroomMoveByFloor(floor: floor).errorMap,
                       let mappedError = errorMap[code] {
                        continuation.resume(throwing: mappedError)
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    public func getClassroomMoveByClassroom(grade: Int, classNum: Int) async throws -> [ClassroomMoveListResponseDTO] {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.getClasssroomMoveByClassroom(grade: grade, classNum: classNum)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map([ClassroomMoveListResponseDTO].self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = ClassroomMoveListAPI.getClasssroomMoveByClassroom(grade: grade, classNum: classNum).errorMap,
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
