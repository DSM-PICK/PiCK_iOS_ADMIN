import Combine

public protocol RemoteAuthDataSource {
    func signin(req: SigninRequestParams) -> AnyPublisher<TokenDTO, Error>
    func refreshToken() -> AnyPublisher<TokenDTO, Error>
    func secretKey(req: SecretKeyRequestParams) -> AnyPublisher<Bool, Error>
    func signup(req: SignupRequestParams) -> AnyPublisher<TokenDTO, Error>
    func withdraw() -> AnyPublisher<Void, Error>
}
