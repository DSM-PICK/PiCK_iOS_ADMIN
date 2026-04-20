import NeedleFoundation
import SwiftUI
import CheckSelfStudyTeacherFeatureInterface
import CheckSelfStudyTeacherDomainInterface
import ComposableArchitecture

public protocol CheckSelfStudyTeacherDependency: NeedleFoundation.Dependency {
    var fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol { get }
}

public final class CheckSelfStudyTeacherComponent:
    Component<CheckSelfStudyTeacherDependency>,
    CheckSelfStudyTeacherFactory {
    public func makeView() -> AnyView {
        AnyView(
            CheckSelfStudyTeacherFeature(
                store: .init(
                    initialState: CheckSelfStudyTeacherReducer.State(),
                    reducer: {
                        CheckSelfStudyTeacherReducer(
                            fetchSelfStudyTeacherUseCase: dependency.fetchSelfStudyTeacherUseCase
                        )
                    }
                )
            )
        )
    }
}
