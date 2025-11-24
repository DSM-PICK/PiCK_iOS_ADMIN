import Foundation
import Combine

public protocol SchoolMealDataSource {
    func getMeal(date: String) -> AnyPublisher<[SchoolMealDTO], Error>
}
