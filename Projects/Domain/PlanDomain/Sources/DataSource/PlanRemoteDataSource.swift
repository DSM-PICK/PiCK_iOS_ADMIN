import Foundation
import Moya
import CombineMoya
import Combine

public protocol PlanRemoteDataSource {
    func fetchAcademicScheduleByDate(date: String) async throws -> AcademicScheduleResponseDTOArray
    func fetchMonthAcademicSchedule(year: String, month: String) async throws -> AcademicScheduleResponseDTOArray
}

public final class PlanRemoteDataSourceImpl: PlanRemoteDataSource {
    private let provider: MoyaProvider<PlanAPI>
    
    public init(provider: MoyaProvider<PlanAPI> = MoyaProvider<PlanAPI>(
        plugins: [NetworkLoggerPlugin(configuration: .init(logOptions: .verbose))]
    )) {
        self.provider = provider
    }
    
    public func fetchAcademicScheduleByDate(date: String) async throws -> AcademicScheduleResponseDTOArray {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.fetchAcademicScheduleByDate(date: date)) { result in
                switch result {
                case let .success(response):
                    do {
                        let data = try response.map(AcademicScheduleResponseDTOArray.self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
    
    public func fetchMonthAcademicSchedule(year: String, month: String) async throws -> AcademicScheduleResponseDTOArray {
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(.fetchMonthAcademicSchedule(year: year, month: month)) { result in
                switch result {
                case let .success(response):
                    do {
                        let data = try response.map(AcademicScheduleResponseDTOArray.self)
                        continuation.resume(returning: data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case let .failure(error):
                    continuation.resume(throwing: error)
                }
            }
        }
    }
}
