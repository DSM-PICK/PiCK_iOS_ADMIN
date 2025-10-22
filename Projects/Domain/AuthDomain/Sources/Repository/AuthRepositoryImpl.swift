import Foundation
import AuthDomainInterface
import RxSwift
import Core


public class AuthRepositoryImpl: AuthRepository {
    private let remoteDataSource: RemoteAuthDataSource
    private let localDataSource: LocalAuthDataSource
    private var disposeBag = DisposeBag()
    private let keyChain = KeychainImpl()

    public init(localDataSource: LocalAuthDataSource, remoteDataSource: RemoteAuthDataSource) {
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
    }

    public func login(req: LoginRequestParams) -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create {} }

            self.remoteDataSource.login(req: req)
                .subscribe(onSuccess: { tokenData in
                    self.keyChain.save(type: .accessToken, value: tokenData.accessToken)
                    self.keyChain.save(type: .refreshToken, value: tokenData.refreshToken)

                    self.keyChain.save(type: .id, value: req.adminID)
                    self.keyChain.save(type: .password, value: req.password)

                    completable(.completed)
                }, onFailure: {
                    completable(.error($0))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create {}
        }
    }

    public func logout() {}

    public func refreshToken() -> Completable {
        return Completable.create { [weak self] completable in
            guard let self = self else { return Disposables.create {} }

            self.remoteDataSource.refreshToken()
                .subscribe(onSuccess: { tokenData in
                    self.keyChain.save(type: .accessToken, value: tokenData.accessToken)
                    self.keyChain.save(type: .refreshToken, value: tokenData.refreshToken)
                    completable(.completed)
                }, onFailure: {
                    completable(.error($0))
                })
                .disposed(by: self.disposeBag)

            return Disposables.create {}
        }
    }

}
