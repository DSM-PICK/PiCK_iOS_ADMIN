import Foundation
import NeedleFoundation
import SwiftUI
import SchoolMealFeature
import SchoolMealFeatureInterface
import SchoolMealDomain
import SchoolMealDomainInterface
import BaseDomain

public protocol SchoolMealDependency: Dependency {}

public final class SchoolMealComponent: Component<SchoolMealDependency>, SchoolMealFactory {
    public func makeSchoolMealView() -> AnyView {
        let schoolMealComponent = SchoolMealComponentImpl()
        
        return schoolMealComponent.makeSchoolMealView()
    }
}

public extension AppComponent {
    var schoolMealFactory: any SchoolMealFactory {
        SchoolMealComponent(parent: self)
    }
}
