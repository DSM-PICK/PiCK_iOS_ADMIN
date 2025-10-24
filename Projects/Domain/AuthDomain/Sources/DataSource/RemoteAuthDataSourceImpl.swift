import AuthDomainInterface
import BaseDomain
import Combine

public final class RemoteAuthDataSourceImpl: BaseRemoteDataSource<AuthAPI>, RemoteAuthDataSource {
    public func login(req: LoginRequestParams) -> AnyPublisher<TokenDTO, Error> {
        request(.login(req))
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
}
