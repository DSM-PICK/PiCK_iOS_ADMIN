import NeedleFoundation
import SwiftUI
import AllTabFeatureInterface
import ComposableArchitecture
import AllTabDomainInterface
import AuthDomainInterface
import CheckSelfStudyTeacherDomainInterface

public protocol AllTabDependency: NeedleFoundation.Dependency {
    var getMyNameUseCase: any GetMyNameUseCaseProtocol { get }
    var authRepository: any AuthRepository { get }
    var fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol { get }
}

public final class AllTabComponent: Component<AllTabDependency>, AllTabFactory {
    public var fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol {
        dependency.fetchSelfStudyTeacherUseCase
    }

    public func makeView() -> AnyView {
        AnyView(
            AllTabFeature(
                store: .init(
                    initialState: AllTabReducer.State(),
                    reducer: {
                        AllTabReducer(
                            getMyNameUseCase: self.dependency.getMyNameUseCase,
                            authRepository: self.dependency.authRepository
                        )
                    }
                ),
                fetchSelfStudyTeacherUseCase: fetchSelfStudyTeacherUseCase
            )
        )
    }
}
