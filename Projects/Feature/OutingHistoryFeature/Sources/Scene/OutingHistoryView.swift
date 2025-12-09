import Foundation
import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct OutingHistoryView: View {
    @State private var isApplyBottomSheetPresented = false
    let store: StoreOf<OutingHistoryReducer>

    public init(store: StoreOf<OutingHistoryReducer>) {
        self.store = store
    }

    public var body: some View {}
}
