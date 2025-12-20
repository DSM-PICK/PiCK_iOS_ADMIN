import Foundation
import Combine

public protocol AllTabDataSource {
    func getMyName() -> AnyPublisher<MyNameResponseDTO, Error>
}
