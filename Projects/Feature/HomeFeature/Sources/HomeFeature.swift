import SwiftUI
import ComposableArchitecture
import AllTabFeatureInterface
import PlanFeatureInterface
import SchoolMealFeatureInterface
import AcceptFeatureInterface

public struct HomeFeature: View {
    let store: Store<HomeReducer.State, HomeReducer.Action>
    let allTabFactory: any AllTabFactory
    let planFactory: any PlanFactory
    let schoolMealFactory: any SchoolMealFactory
    let acceptFactory: any AcceptFactory

    public init(
        store: Store<HomeReducer.State, HomeReducer.Action>,
        allTabFactory: any AllTabFactory,
        planFactory: any PlanFactory,
        schoolMealFactory: any SchoolMealFactory,
        acceptFactory: any AcceptFactory
    ) {
        self.store = store
        self.allTabFactory = allTabFactory
        self.planFactory = planFactory
        self.schoolMealFactory = schoolMealFactory
        self.acceptFactory = acceptFactory
    }

    public var body: some View {
        TabBarView(
            store: store,
            allTabFactory: allTabFactory,
            planFactory: planFactory,
            schoolMealFactory: schoolMealFactory,
            acceptFactory: acceptFactory
        )
    }
}
