import SwiftUI
import HomeFeature
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

public struct SchoolMealView: View {
    let store: StoreOf<SchoolMealReducer>
    
    public init(store: StoreOf<SchoolMealReducer>) {
        self.store = store
    }

    public var body: some View {
        VStack {
            Text("급식뷰 텝바 연결")
        }
    }
}
