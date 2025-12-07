import NeedleFoundation
import SwiftUI
import ClassroomMoveListFeatureInterface
import ComposableArchitecture
import ClassroomMoveListDomainInterface

public protocol ClassroomMoveListDependency: NeedleFoundation.Dependency {}

public final class ClassroomMoveListComponent: Component<ClassroomMoveListDependency>, ClassroomMoveListFactory {
    public func makeView() -> AnyView {
        AnyView(
            ClassroomMoveListView(
                store: .init(
                    initialState: ClassroomMoveListReducer.State(),
                    reducer: {
                        ClassroomMoveListReducer()
                    }
                )
            )
        )
    }
}
