import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import AllTabDomainInterface

public struct AllTabView: View {
    let store: StoreOf<AllTabReducer>
    
    public init(store: StoreOf<AllTabReducer>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                if let myName = viewStore.myName {
                    Text("이름: \(myName.name)")
                        .pickText(type: .label1)
                    
                    Text("학년: \(myName.grade)")
                        .pickText(type: .body1)
                    
                    Text("반: \(myName.classNum)")
                        .pickText(type: .body1)
                } else {
                    Text("로딩 중...")
                        .pickText(type: .body1)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewStore.send(.fetchMyName)
            }
        }
    }
}
