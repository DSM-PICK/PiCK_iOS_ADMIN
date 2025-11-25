import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import AllTabFeatureInterface
import PlanFeatureInterface
import AcceptFeatureInterface

public struct TabBarView: View {
    @State private var selectedTab = 2
    let store: StoreOf<HomeReducer>
    let allTabFactory: any AllTabFactory
    let planFactory: any PlanFactory
    let acceptFactory: any AcceptFactory
    
    public init(
        store: StoreOf<HomeReducer>,
        allTabFactory: any AllTabFactory,
        planFactory: any PlanFactory,
        acceptFactory: any AcceptFactory
    ) {
        self.store = store
        self.allTabFactory = allTabFactory
        self.planFactory = planFactory
        self.acceptFactory = acceptFactory
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            Text("급식")
                .tag(0)
                .tabItem {
                    Label("급식", systemImage: "fork.knife")
                }
            
            planFactory.makePlanView()
                .tag(1)
                .tabItem {
                    Label("일정", systemImage: "calendar")
                }
            
            NavigationView {
                HomeView(store: store)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(.stack)
            .tag(2)
            .tabItem {
                Label("홈", systemImage: "house")
            }
            
            acceptFactory.makeView()
                .tag(3)
                .tabItem {
                    Label("수락", systemImage: "checkmark.circle")
                }
            
            allTabFactory.makeView()
                .tag(4)
                .tabItem {
                    Label("전체", systemImage: "list.bullet")
                }
        }
        .tint(Color.Primary.primary500)
    }
}
