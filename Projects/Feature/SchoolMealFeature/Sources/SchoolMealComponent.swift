import SwiftUI
import ComposableArchitecture
import SchoolMealFeatureInterface
import SchoolMealDomainInterface

public struct SchoolMealComponentImpl: SchoolMealFactory {

    public init() {}
    
    public func makeSchoolMealView() -> AnyView {
        let store = Store(
            initialState: SchoolMealReducer.State(),
            reducer: {
                SchoolMealReducer()
            }
        )
        
        return AnyView(SchoolMealFeature(store: store))
    }
}
