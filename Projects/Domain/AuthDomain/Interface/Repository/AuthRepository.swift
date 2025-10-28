import Combine

public protocol AuthRepository {
    func signin(req: SigninRequestParams) -> AnyPublisher<Void, Error>
    func refreshToken() -> AnyPublisher<Void, Error>
    func secretKey(req: SecretKeyRequestParams) -> AnyPublisher<Void, Error>
    func logout()
}
