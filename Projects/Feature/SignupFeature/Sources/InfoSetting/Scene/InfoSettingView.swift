import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility
import BaseFeature

struct InfoSettingView: View {
    let store: StoreOf<InfoSettingReducer>
    @EnvironmentObject var router: AppRouter

    public init(store: StoreOf<InfoSettingReducer>) {
        self.store = store
    }

    var body: some View {
        Text("info setting")
    }
}
