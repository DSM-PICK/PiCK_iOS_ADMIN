import SwiftUI
import PiCK_iOS_DesignSystem

struct PiCKNavigationBar: View {
    var body: some View {
        HStack {
            PiCKImage.pickLogo
                .resizable()
                .scaledToFit()
                .frame(height: 20)
            
            Spacer()
        }
        .frame(height: 34)
        .padding(.leading, 24)
    }
}
