import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import AllTabFeatureInterface

public struct TabBarView: View {
    @State private var selectedTab = 2
    let store: StoreOf<HomeReducer>
    let allTabFactory: any AllTabFactory
    
    public init(
        store: StoreOf<HomeReducer>,
        allTabFactory: any AllTabFactory
    ) {
        self.store = store
        self.allTabFactory = allTabFactory
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            Text("급식")
                .tag(0)
                .tabItem {
                    Label("급식", systemImage: "fork.knife")
                }
            
            Text("일정")
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
            
            Text("수락")
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
