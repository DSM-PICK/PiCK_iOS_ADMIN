import Foundation
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public class OnboardingViewModel: BaseViewModel, Stepper {
    private let disposeBag = DisposeBag()
    public var steps = PublishRelay<Step>()

    private let keychain = KeychainImpl()

    private let refreshTokenUseCase: RefreshTokenUseCase
    private let loginUseCase: LoginUseCase

    public init(
        refreshTokenUseCase: RefreshTokenUseCase,
        loginUseCase: LoginUseCase
    ) {
        self.refreshTokenUseCase = refreshTokenUseCase
        self.loginUseCase = loginUseCase
    }

    public struct Input {
        let viewWillAppear: Observable<Void>
    }
    public struct Output {
        let presentAlert: Signal<Void>
    }

    private let presentAlert = PublishRelay<Void>()

    public func transform(input: Input) -> Output {
        input.viewWillAppear
            .flatMap {
                self.refreshTokenUseCase.execute()
                    .catch { _ in
                        return self.loginUseCase.execute(req: .init(
                            accountID: self.keychain.load(type: .id),
                            password: self.keychain.load(type: .password),
                            deviceToken: ""
                        ))
                        .catch { error in
                            guard let error = error as? PiCKError
                            else { return .never() }

                            return .never()
                        }
                    }
                    .andThen(Single.just(PiCKStep.tabIsRequired))
            }
            .bind(to: steps)
            .disposed(by: disposeBag)
        return Output(
            presentAlert: presentAlert.asSignal()
        )
    }
}
