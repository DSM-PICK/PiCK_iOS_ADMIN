import SwiftUI
import ComposableArchitecture
import SchoolMealFeatureInterface
import SchoolMealDomainInterface

public struct SchoolMealComponentImpl: SchoolMealFactory {
    private let fetchSchoolMealsUseCase: FetchSchoolMealUseCaseProtocol

    public init(fetchSchoolMealsUseCase: FetchSchoolMealUseCaseProtocol) {
        self.fetchSchoolMealsUseCase = fetchSchoolMealsUseCase
    }
    
    public func makeSchoolMealView() -> AnyView {
        let store = Store(
            initialState: SchoolMealReducer.State(),
            reducer: {
                SchoolMealReducer(
                    fetchSchoolMealsUseCase: fetchSchoolMealsUseCase
                )
            }
        )
        
        return AnyView(SchoolMealFeature(store: store))
    }
}
