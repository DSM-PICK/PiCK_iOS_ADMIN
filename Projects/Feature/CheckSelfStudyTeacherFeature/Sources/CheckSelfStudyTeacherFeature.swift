import SwiftUI
import ComposableArchitecture

public struct CheckSelfStudyTeacherFeature: View {
    let store: StoreOf<CheckSelfStudyTeacherReducer>

    public init(store: StoreOf<CheckSelfStudyTeacherReducer>) {
        self.store = store
    }

    public var body: some View {
        CheckSelfStudyTeacherView(store: store)
    }
}
