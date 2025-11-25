import SwiftUI
import PiCK_iOS_DesignSystem

public struct PiCKNavigationBar: View {
    public init() {}
    
    public var body: some View {
        PiCKImage.pickLogo
            .resizable()
            .scaledToFit()
            .frame(height: 20)
    }
}
