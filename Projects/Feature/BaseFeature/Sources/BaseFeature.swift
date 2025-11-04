import Foundation
import SwiftUI

public struct BaseView<Content: View>: View {
    let content: Content
    @State private var isPopupPresented: Bool = false

    public init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }

    public var body: some View {
        content
            .contentShape(Rectangle())
            .simultaneousGesture(
                TapGesture().onEnded { _ in
                    UIApplication.shared.hideKeyboard()
                }
            )
    }
}

extension UIApplication {
    func hideKeyboard() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
