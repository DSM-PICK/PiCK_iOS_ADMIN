import ComposableArchitecture
import AuthDomainInterface

public struct InfoSettingReducer: Reducer {
    public struct State: Equatable {
        public var secretKey = ""
        public var accountId = ""
        public var code = ""
        public var password = ""

        public init(secretKey: String = "", accountId: String = "", code: String = "", password: String = "") {
            self.secretKey = secretKey
            self.accountId = accountId
            self.code = code
            self.password = password
        }
    }

    public enum Action {}

    public var body: some Reducer<State, Action> {}
}
