import SwiftUI
import ComposableArchitecture
import AllTabFeatureInterface

public struct HomeFeature: View {
    let store: Store<HomeReducer.State, HomeReducer.Action>
    let allTabFactory: any AllTabFactory

    public init(
        store: Store<HomeReducer.State, HomeReducer.Action>,
        allTabFactory: any AllTabFactory
    ) {
        self.store = store
        self.allTabFactory = allTabFactory
    }

    public var body: some View {
        TabBarView(
            store: store,
            allTabFactory: allTabFactory
        )
    }
}
