import ComposableArchitecture
import AuthDomainInterface

public struct InfoSettingReducer: Reducer {
    public struct State: Equatable {
        public var secretKey = ""
        public var accountId = ""
        public var code = ""
        public var password = ""
        public var name = ""
        public var selectedGrade = 0
        public var selectedClass = 0

        public init(secretKey: String = "", accountId: String = "", code: String = "", password: String = "") {
            self.secretKey = secretKey
            self.accountId = accountId
            self.code = code
            self.password = password
        }
    }

    public enum Action {
        case nameChanged(String)
        case selectedGradeChanged(Int?)
        case selectedClassChanged(Int?)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .nameChanged(name):
                state.name = name
                return .none
            case let .selectedGradeChanged(grade):
                state.selectedGrade = grade ?? 0
                return .none
            case let .selectedClassChanged(klass):
                state.selectedClass = klass ?? 0
                return .none
            }
        }
    }
}
