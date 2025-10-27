import Foundation
import AuthDomainInterface
import Combine
import Core

public class AuthRepositoryImpl: AuthRepository {
    private let remoteDataSource: RemoteAuthDataSource
    private let localDataSource: LocalAuthDataSource
    private var cancellables = Set<AnyCancellable>()
    private let keyChain = KeychainImpl()

    public init(localDataSource: LocalAuthDataSource, remoteDataSource: RemoteAuthDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    public func signin(req: SigninRequestParams) -> AnyPublisher<Void, Error> {
        remoteDataSource.signin(req: req)
            .handleEvents(receiveOutput: { [weak self] tokenData in
                guard let self = self else { return }
                self.keyChain.save(type: .accessToken, value: tokenData.accessToken)
                self.keyChain.save(type: .refreshToken, value: tokenData.refreshToken)
                self.keyChain.save(type: .id, value: req.adminID)
                self.keyChain.save(type: .password, value: req.password)
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public func refreshToken() -> AnyPublisher<Void, Error> {
        remoteDataSource.refreshToken()
            .handleEvents(receiveOutput: { [weak self] tokenData in
                guard let self = self else { return }
                self.keyChain.save(type: .accessToken, value: tokenData.accessToken)
                self.keyChain.save(type: .refreshToken, value: tokenData.refreshToken)
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public func logout() {}
}
