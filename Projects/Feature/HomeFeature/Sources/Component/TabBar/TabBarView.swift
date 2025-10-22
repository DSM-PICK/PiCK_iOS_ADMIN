import SwiftUI
import PiCK_iOS_DesignSystem

public struct TabBarView: View {
    @State private var selectedTab = 2
    
    public init() {}
    
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
            
            HomeView()
                .tag(2)
                .tabItem {
                    Label("홈", systemImage: "house")
                }
            
            Text("수락")
                .tag(3)
                .tabItem {
                    Label("수락", systemImage: "checkmark.circle")
                }
            
            Text("전체")
                .tag(4)
                .tabItem {
                    Label("전체", systemImage: "list.bullet")
                }
        }
        .tint(Color.Primary.primary500)
    }
}
