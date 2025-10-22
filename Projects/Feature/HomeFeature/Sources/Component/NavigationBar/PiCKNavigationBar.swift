import SwiftUI
import PiCK_iOS_DesignSystem

struct PiCKNavigationBar: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            PiCKImage.pickLogo
                .resizable()
                .scaledToFit()
                .frame(height: 20)
                .padding(.leading, 24)
                .padding(.bottom, 7.31)
        }
        .frame(height: 34)
        .frame(maxWidth: .infinity)
    }
}
