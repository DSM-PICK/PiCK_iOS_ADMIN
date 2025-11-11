import SwiftUI

public struct AcceptView: View {
    public init() {}
    public var body: some View {
        Text("Accept View")
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    PiCKNavigationBar()
                        .padding(.leading, 8)
                }
            }
    }
}
