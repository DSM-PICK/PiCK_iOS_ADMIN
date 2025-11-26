import SwiftUI
import ComposableArchitecture

public protocol SchoolMealFactory {
    func makeSchoolMealView() -> AnyView
}
