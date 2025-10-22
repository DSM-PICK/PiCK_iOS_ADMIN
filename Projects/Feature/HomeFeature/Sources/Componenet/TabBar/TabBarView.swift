import SwiftUI
import PiCK_iOS_DesignSystem

public struct TabBarView: View {
    
    init() {}
    
    public var body: some View {
        TabView {
            Text("급식")
                .tabItem {
                    Label("급식", systemImage: "fork.knife")
                }
            
            Text("일정")
                .tabItem {
                    Label("일정", systemImage: "calendar")
                }

            Text("홈")
                .tabItem {
                    Label("홈", systemImage: "house")
                }

            Text("수락")
                .tabItem {
                    Label("수락", systemImage: "checkmark.circle")
                }

            Text("전체")
                .tabItem {
                    Label("전체", systemImage: "list.bullet")
                }
        }
        .tint(Color.Primary.primary500)
    }
}
