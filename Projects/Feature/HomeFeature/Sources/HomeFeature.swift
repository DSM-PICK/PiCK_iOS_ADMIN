import SwiftUI
import ComposableArchitecture
import AllTabFeatureInterface
import PlanFeatureInterface
import SchoolMealFeatureInterface

public struct HomeFeature: View {
    let store: Store<HomeReducer.State, HomeReducer.Action>
    let allTabFactory: any AllTabFactory
    let planFactory: any PlanFactory
    let schoolMealFactory: any SchoolMealFactory

    public init(
        store: Store<HomeReducer.State, HomeReducer.Action>,
        allTabFactory: any AllTabFactory,
        planFactory: any PlanFactory,
        schoolMealFactory: any SchoolMealFactory
    ) {
        self.store = store
        self.allTabFactory = allTabFactory
        self.planFactory = planFactory
        self.schoolMealFactory = schoolMealFactory
    }

    public var body: some View {
        TabBarView(
            store: store,
            allTabFactory: allTabFactory,
            planFactory: planFactory,
            schoolMealFactory: schoolMealFactory
        )
    }
}
