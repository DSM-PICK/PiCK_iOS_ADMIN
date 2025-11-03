import AuthDomainInterface
import BaseDomain
import Combine

public final class RemoteAuthDataSourceImpl: BaseRemoteDataSource<AuthAPI>, RemoteAuthDataSource {
    public func signin(req: SigninRequestParams) -> AnyPublisher<TokenDTO, Error> {
        request(.signin(req))
            .tryMap { response in
                try response.map(TokenDTO.self)
            }
            .eraseToAnyPublisher()
    }
    public func refreshToken() -> AnyPublisher<TokenDTO, Error> {
        request(.refreshToken)
            .tryMap { response in
                try response.map(TokenDTO.self)
            }
            .eraseToAnyPublisher()
    }
    public func secretKey(req: SecretKeyRequestParams) -> AnyPublisher<Bool, Error> {
        request(.secretKey(req))
            .tryMap { response in
                try response.map(Bool.self)
            }
            .eraseToAnyPublisher()
    }
    public func signup(req: SignupRequestParams) -> AnyPublisher<TokenDTO, Error> {
        request(.signup(req))
            .tryMap { response in
                try response.map(TokenDTO.self)
            }
            .eraseToAnyPublisher()
    }
}
