import Foundation

public protocol OutListRepository {
    func getOutList(floor: Int) async throws -> [OutListEntity]
}
