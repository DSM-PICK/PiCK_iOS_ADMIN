import AuthDomainInterface
import BaseDomain
import RxSwift

public final class RemoteAuthDataSourceImpl: BaseRemoteDataSource<AuthAPI>, RemoteAuthDataSource {

    public func login(req: LoginRequestParams) -> Single<TokenDTO> {
        request(.login(req))
            .map(TokenDTO.self)
    }

    public func refreshToken() ->  Single<TokenDTO> {
        request(.refreshToken)
            .map(TokenDTO.self)
    }
}
