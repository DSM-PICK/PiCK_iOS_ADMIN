import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import AllTabDomainInterface
import HomeFeature

public struct AllTabView: View {
    let store: StoreOf<AllTabReducer>
    
    public init(store: StoreOf<AllTabReducer>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(spacing: 20) {
                if let myName = viewStore.myName {
                    Text("\(myName.name)")
                        .pickText(type: .heading1)
                    
                    Text("\(myName.grade)학년 \(myName.classNum)반")
                        .pickText(type: .body1)
                } else {
                    ProgressView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .onAppear {
                viewStore.send(.fetchMyName)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    PiCKNavigationBar()
                        .padding(.leading, 8)
                }
            }
        }
    }
}

