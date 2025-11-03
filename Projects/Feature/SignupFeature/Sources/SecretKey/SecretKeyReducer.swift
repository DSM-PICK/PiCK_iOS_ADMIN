import ComposableArchitecture
import AuthDomainInterface

public struct SecretKeyReducer: Reducer {
    private let signinUseCase: any SigninUseCase

    public init(signinUseCase: any SigninUseCase) {
        self.signinUseCase = signinUseCase
    }

    public struct State: Equatable {
        public var secretKey = ""
        public init() {}
    }

    public enum Action {
        case secretKeyChanged(String)
        case nextButtonTapped
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .secretKeyChanged(secretKey):
                state.secretKey = secretKey
                return .none
            case .nextButtonTapped:
                // Handle login logic here
                return .none
            }
        }
    }
}
