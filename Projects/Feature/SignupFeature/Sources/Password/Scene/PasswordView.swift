import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility
import BaseFeature

struct PasswordView: View {
    let store: StoreOf<PasswordReducer>
    @EnvironmentObject var router: AppRouter

    public init(store: StoreOf<PasswordReducer>) {
        self.store = store
    }

    var body: some View {
        Text("password")
    }
}
