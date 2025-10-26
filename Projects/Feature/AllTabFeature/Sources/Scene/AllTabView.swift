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
            NavigationStack {
                ScrollView {
                    VStack(spacing: 0) {
                        if let myName = viewStore.myName {
                            TeacherInfoView(teacherName: myName.name)
                                .padding(.top, 24)
                            
                            MenuListView(sections: createMenuSections())
                                .padding(.top, 32)
                        } else {
                            ProgressView()
                        }
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    viewStore.send(.fetchMyName)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        PiCKNavigationBar()
                            .padding(.leading, 8)
                    }
                }
            }
        }
    }
}

