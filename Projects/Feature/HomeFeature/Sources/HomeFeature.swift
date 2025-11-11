import SwiftUI
import ComposableArchitecture
import AllTabFeatureInterface
import PlanFeatureInterface
import AcceptFeatureInterface

public struct HomeFeature: View {
    let store: Store<HomeReducer.State, HomeReducer.Action>
    let allTabFactory: any AllTabFactory
    let planFactory: any PlanFactory
    let acceptFactory: any AcceptFactory

    public init(
        store: Store<HomeReducer.State, HomeReducer.Action>,
        allTabFactory: any AllTabFactory,
        planFactory: any PlanFactory,
        acceptFactory: any AcceptFactory
    ) {
        self.store = store
        self.allTabFactory = allTabFactory
        self.planFactory = planFactory
        self.acceptFactory = acceptFactory
    }

    public var body: some View {
        TabBarView(
            store: store,
            allTabFactory: allTabFactory,
            planFactory: planFactory,
            acceptFactory: acceptFactory
        )
    }
}
