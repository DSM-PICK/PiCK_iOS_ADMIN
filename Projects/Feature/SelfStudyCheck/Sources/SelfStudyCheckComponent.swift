import NeedleFoundation
import SwiftUI
import SelfStudyCheckFeatureInterface
import SelfStudyCheckDomainInterface
import ComposableArchitecture

public protocol SelfStudyCheckDependency: NeedleFoundation.Dependency {
    var getStudentAttendanceUseCase: any GetStudentAttendanceUseCase { get }
    var saveAttendanceUseCase: any SaveAttendanceUseCase { get }
}

public final class SelfStudyCheckComponent: Component<SelfStudyCheckDependency>, SelfStudyCheckFactory {
    public func makeView() -> AnyView {
        AnyView(
            SelfStudyCheckView(
                store: .init(
                    initialState: SelfStudyCheckReducer.State(),
                    reducer: {
                        SelfStudyCheckReducer(
                            getStudentAttendanceUseCase: self.dependency.getStudentAttendanceUseCase,
                            saveAttendanceUseCase: self.dependency.saveAttendanceUseCase
                        )
                    }
                )
            )
        )
    }
}
