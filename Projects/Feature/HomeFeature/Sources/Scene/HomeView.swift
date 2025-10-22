
import SwiftUI

public struct HomeView: View {
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            TabBarView()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                PiCKNavigationBar()
            }
        }
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
