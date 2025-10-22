import SwiftUI
import PiCK_iOS_DesignSystem

public struct HomeView: View {
    
    public init() {}
    
    public var body: some View {
        VStack(spacing: 0) {
            SelfStudyView()
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .frame(height: 72)
            
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                PiCKNavigationBar()
                    .padding(.leading, 8)
            }
        }
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.hidden, for: .navigationBar)
    }
}
