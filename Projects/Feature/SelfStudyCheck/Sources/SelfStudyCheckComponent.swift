import NeedleFoundation
import SwiftUI
import SelfStudyCheckFeatureInterface
import SelfStudyCheckDomainInterface
import ComposableArchitecture

public protocol SelfStudyCheckDependency: NeedleFoundation.Dependency {
    var getStudentAttendanceUseCase: any GetStudentAttendanceUseCase { get }
}

public final class SelfStudyCheckComponent: Component<SelfStudyCheckDependency>, SelfStudyCheckFactory {
    public func makeView() -> AnyView {
        AnyView(
            NavigationView {
                SelfStudyCheckFeature(
                    store: .init(
                        initialState: SelfStudyCheckReducer.State(),
                        reducer: {
                            SelfStudyCheckReducer(getStudentAttendanceUseCase: self.dependency.getStudentAttendanceUseCase)
                        }
                    )
                )
            }
        )
    }
}
