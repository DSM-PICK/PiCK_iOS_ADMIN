import Foundation
import SwiftUI

public protocol OnboardingFactory {
    func makeView() -> AnyView
}
