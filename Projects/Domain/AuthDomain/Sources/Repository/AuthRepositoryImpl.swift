import Foundation
import AuthDomainInterface
import Combine
import Core
import BaseDomain

public class AuthRepositoryImpl: AuthRepository {
    private let remoteDataSource: RemoteAuthDataSource
    private let localDataSource: LocalAuthDataSource
    private let keyChain: Keychain
    private var cancellables = Set<AnyCancellable>()

    public init(
        keychain: Keychain,
        localDataSource: LocalAuthDataSource,
        remoteDataSource: RemoteAuthDataSource
    ) {
        self.keyChain = keychain
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    public func signin(req: SigninRequestParams) -> AnyPublisher<Void, Error> {
        remoteDataSource.signin(req: req)
            .handleEvents(receiveOutput: { [weak self] tokenData in
                self?.saveTokens(tokenData, with: req)
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public func refreshToken() -> AnyPublisher<Void, Error> {
        remoteDataSource.refreshToken()
            .handleEvents(receiveOutput: { tokenData in
                JwtStore.shared.accessToken = tokenData.accessToken
                JwtStore.shared.refreshToken = tokenData.refreshToken
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public func secretKey(req: SecretKeyRequestParams) -> AnyPublisher<Bool, Error> {
        remoteDataSource.secretKey(req: req)
            .map { response in
                return response
            }
            .eraseToAnyPublisher()
    }

    public func signup(req: SignupRequestParams) -> AnyPublisher<Void, Error> {
        remoteDataSource.signup(req: req)
            .handleEvents(receiveOutput: { [weak self] tokenData in
                self?.saveTokens(tokenData, with: req)
            })
            .map { _ in () }
            .eraseToAnyPublisher()
    }

    public func logout() {
        JwtStore.shared.clearTokens()
        localDataSource.logout()
    }
    
    private func saveTokens(_ tokenData: TokenDTO, with req: SigninRequestParams) {
        JwtStore.shared.accessToken = tokenData.accessToken
        JwtStore.shared.refreshToken = tokenData.refreshToken
        keyChain.save(type: .id, value: req.adminID)
        keyChain.save(type: .password, value: req.password)
    }

    private func saveTokens(_ tokenData: TokenDTO, with req: SignupRequestParams) {
        JwtStore.shared.accessToken = tokenData.accessToken
        JwtStore.shared.refreshToken = tokenData.refreshToken
        keyChain.save(type: .id, value: req.accountId)
        keyChain.save(type: .password, value: req.password)
    }
}
