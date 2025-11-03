import Combine

public protocol AuthRepository {
    func signin(req: SigninRequestParams) -> AnyPublisher<Void, Error>
    func refreshToken() -> AnyPublisher<Void, Error>
    func secretKey(req: SecretKeyRequestParams) -> AnyPublisher<Bool, Error>
    func signup(req: SignupRequestParams) -> AnyPublisher<Void, Error>
    func logout()
}
