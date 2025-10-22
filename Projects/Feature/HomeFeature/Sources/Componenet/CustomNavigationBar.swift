
import SwiftUI

struct CustomNavigationBar: View {
    var body: some View {
        ZStack(alignment: .bottomLeading) {
            Text("PiCK")
                .font(.system(size: 20, weight: .black))
                .padding(.leading, 24)
                .padding(.bottom, 7.31)
        }
        .frame(height: 34)
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}
