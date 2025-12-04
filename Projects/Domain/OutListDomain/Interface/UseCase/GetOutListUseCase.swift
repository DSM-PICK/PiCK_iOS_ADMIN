import Foundation

public protocol GetOutListUseCase {
    func execute(floor: Int) async throws -> [OutListEntity]
}
