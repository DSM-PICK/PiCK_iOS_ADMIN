import SwiftUI
import PiCK_iOS_DesignSystem

public struct PlanView: View {
    public init() {}
    
    public var body: some View {
        NavigationView {
            ZStack {
                Color.Background.background
                    .ignoresSafeArea()
                
                VStack {
                    Text("일정")
                        .pickText(type: .label1)
                        .foregroundColor(.black)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    PiCKImage.pickLogo
                        .resizable()
                        .scaledToFit()
                        .frame(height: 20)
                }
            }
        }
    }
}
