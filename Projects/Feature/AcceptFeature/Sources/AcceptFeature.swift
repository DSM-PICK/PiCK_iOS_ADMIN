import SwiftUI
import AcceptFeatureInterface

public struct AcceptFeature: AcceptFeatureInterface {
    
    public init() {}
    
    public func makeView() -> AnyView {
        AnyView(
            NavigationView {
                AcceptView()
            }
        )
    }
}
