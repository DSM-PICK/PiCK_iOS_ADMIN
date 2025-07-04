import Foundation

import RxSwift
import RxCocoa
import RxFlow

import ReactorKit

import Core
import Domain

import FirebaseMessaging

public final class LoginReactor: BaseReactor {
    public var steps = PublishRelay<Step>()
    public var initialState: State

    private let loginUseCase: LoginUseCase

    init(loginUseCase: LoginUseCase) {
        self.initialState = .idle
        self.loginUseCase = loginUseCase
    }

    public enum Action {}

    public enum State {
        case idle
    }
}
