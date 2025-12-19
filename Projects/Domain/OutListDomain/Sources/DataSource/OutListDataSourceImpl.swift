import Foundation
import BaseDomain
import Core
import Moya
import OutListDomainInterface

public final class OutListDataSourceImpl: OutListDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<OutListAPI>

    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<OutListAPI>(plugins: [MoyaLoggingPlugin()])
    }

    public func getOutList(floor: Int) async throws -> [OutListResponseDTO] {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.getOutList(floor: floor)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map([OutListResponseDTO].self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = OutListAPI.getOutList(floor: floor).errorMap,
                       let mappedError = errorMap[code] {
                        continuation.resume(throwing: mappedError)
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    public func returnStudents(ids: [String]) async throws {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.returnStudents(ids: ids)) { result in
                switch result {
                case .success:
                    continuation.resume(returning: ())
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = OutListAPI.returnStudents(ids: ids).errorMap,
                       let mappedError = errorMap[code] {
                        continuation.resume(throwing: mappedError)
                    } else {
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }

    public func getEarlyReturn(floor: Int, status: String) async throws -> [EarlyReturnResponseDTO] {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(.earlyReturnList(floor: floor, status: status)) { result in
                switch result {
                case .success(let response):
                    do {
                        let data = try response.map([EarlyReturnResponseDTO].self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    if let moyaError = error as? MoyaError,
                       let code = moyaError.response?.statusCode,
                       let errorMap = OutListAPI.earlyReturnList(floor: floor, status: status).errorMap,
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
