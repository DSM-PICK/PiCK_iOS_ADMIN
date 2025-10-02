import BaseFeature
import Combine

final class MicroStore: BaseStore {
    var route: PassthroughSubject<RoutePath, Never> = .init()
    var subscription: Set<AnyCancellable> = .init()
    var initialState: State
    var stateSubject: CurrentValueSubject<State, Never>

    init() {
        self.initialState = .init()
        self.stateSubject = .init(initialState)
    }

    enum Action: Equatable {
        case viewDidLoad
    }

    enum Mutation {

    }

    func mutate(state: State, action: Action) -> SideEffect<Mutation, Never> {
        switch action {
        case .viewDidLoad:
            return .none
        }
    }

    func reduce(state: State, mutate: Mutation) -> State {
        var newState = state
        // No mutations yet
        return newState
    }
}
