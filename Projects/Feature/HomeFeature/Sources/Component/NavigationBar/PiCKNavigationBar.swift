import SwiftUI
import PiCK_iOS_DesignSystem

struct PiCKNavigationBar: View {
    var body: some View {
        PiCKImage.pickLogo
            .resizable()
            .scaledToFit()
            .frame(height: 20)
    }
}
