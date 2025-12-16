import SwiftUI
import PiCK_iOS_DesignSystem

struct AccordionView<Content: View>: View {
    @State private var isExpanded: Bool = false
    let badge: String
    let title: String
    let content: Content
    
    init(badge: String, title: String, @ViewBuilder content: () -> Content) {
        self.badge = badge
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(spacing: 0) {
            Button(action: {
                isExpanded.toggle()
            }) {
                HStack(spacing: 8) {
                    PiCKImage.bottomArrow
                        .foregroundColor(.Normal.black)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .animation(.spring(response: 0.3, dampingFraction: 0.8), value: isExpanded)
                    
                    Text(badge)
                        .pickText(type: .label1, textColor: Color.Primary.primary500)
                    
                    Text(title)
                        .pickText(type: .label1, textColor: Color.Normal.black)
                    
                    Spacer()
                }
                .background(Color.Background.background)
            }
            .buttonStyle(PlainButtonStyle())

            if isExpanded {
                VStack(spacing: 0) {
                    content
                }
                .padding(.horizontal)
                .padding(.bottom)
                .transition(.asymmetric(
                    insertion: .opacity.combined(with: .move(edge: .top)),
                    removal: .opacity.combined(with: .move(edge: .top)))
                )
            }
        }
    }
}
