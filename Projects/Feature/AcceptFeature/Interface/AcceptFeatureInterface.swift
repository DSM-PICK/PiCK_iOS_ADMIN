import SwiftUI

public protocol AcceptFactory {
    func makeView() -> AnyView
}

public protocol AcceptFeatureInterface: AcceptFactory {}
