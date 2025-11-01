import ComposableArchitecture
import AuthDomainInterface

public struct PasswordReducer: Reducer {
    public struct State: Equatable {
        public var secretKey = ""
        public var accountId = ""
        public var code = ""

        public init(secretKey: String = "", accountId: String = "", code: String = "") {
            self.secretKey = secretKey
            self.accountId = accountId
            self.code = code
        }
    }
    
    public enum Action {}
    
    public var body: some Reducer<State, Action> {}
}
