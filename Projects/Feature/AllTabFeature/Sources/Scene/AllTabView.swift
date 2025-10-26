import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import AllTabDomainInterface
import HomeFeature
import Utility

public struct AllTabView: View {
    let store: StoreOf<AllTabReducer>
    @EnvironmentObject var router: AppRouter
    
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
                            
                            AllTabMenuList(onLogoutTap: {
                                viewStore.send(.logoutButtonTapped)
                            })
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
                .onChange(of: viewStore.shouldLogout) { shouldLogout in
                    if shouldLogout {
                        router.path = [.onboarding]
                    }
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
