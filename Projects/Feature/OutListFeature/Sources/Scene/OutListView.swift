import Foundation
import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct OutListView: View {
    let store: StoreOf<OutListReducer>

    public init(store: StoreOf<OutListReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("외출자 목록 화면")
        }
        .navigationTitle("외출자 목록")
        .navigationBarTitleDisplayMode(.inline)
    }
}
