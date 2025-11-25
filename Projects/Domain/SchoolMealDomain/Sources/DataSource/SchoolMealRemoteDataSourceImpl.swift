import Foundation
import Moya
import CombineMoya
import Combine
import BaseDomain
import Core

public final class SchoolMealRemoteDataSourceImpl: SchoolMealRemoteDataSource {
    private let keychain: any Keychain
    private let provider: MoyaProvider<SchoolMealAPI>
    
    public init(keychain: any Keychain) {
        self.keychain = keychain
        self.provider = MoyaProvider<SchoolMealAPI>(plugins: [MoyaLoggingPlugin()])
    }
    
    public func fetchSchoolMeal(date: String) async throws -> SchoolMealDTO {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.fetchSchoolMeal(date: date)) { result in
                switch result {
                case .success(let response):
                    do {
                        let dto = try response.map(SchoolMealDTO.self)
                        continuation.resume(returning: dto)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
