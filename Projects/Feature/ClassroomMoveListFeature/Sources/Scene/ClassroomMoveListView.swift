import Foundation
import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct ClassroomMoveListView: View {
    let store: StoreOf<ClassroomMoveListReducer>
    
    public init(store: StoreOf<ClassroomMoveListReducer>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 0) {}
                    .navigationTitle("교실 이동 현황")
                    .navigationBarTitleDisplayMode(.inline)
            }
        }
    }
}
