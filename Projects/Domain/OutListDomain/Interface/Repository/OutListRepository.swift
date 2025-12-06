import Foundation

public protocol OutListRepository {
    func getOutList(floor: Int) async throws -> [OutListEntity]
    func returnStudents(ids: [String]) async throws
    func getEarlyReturn() async throws -> [EarlyReturnEntity]
}
