import XCTest
import Combine
import ComposableArchitecture
import ChangePasswordDomainInterface
@testable import ChangePasswordFeature

@MainActor
final class NewPasswordReducerTests: XCTestCase {
    func testNewPasswordBinding_UpdatesStateAndClearsError() async {
        let store = makeStore(initialState: state(errorMessage: "old error"))

        await store.send(\.binding.newPassword, "Password1!") {
            $0.newPassword = "Password1!"
            $0.errorMessage = nil
        }
    }

    func testNewPasswordCheckBinding_UpdatesStateAndClearsError() async {
        let store = makeStore(initialState: state(errorMessage: "old error"))

        await store.send(\.binding.newPasswordCheck, "Password1!") {
            $0.newPasswordCheck = "Password1!"
            $0.errorMessage = nil
        }
    }

    func testChangeButtonTapped_WithMismatchedPasswords_SetsValidationError() async {
        let passwordChangeUseCase = PasswordChangeUseCaseSpy()
        let store = makeStore(
            passwordChangeUseCase: passwordChangeUseCase,
            initialState: state(
                newPassword: "Password1!",
                newPasswordCheck: "Password2!"
            )
        )

        await store.send(.changeButtonTapped) {
            $0.errorMessage = "비밀번호가 일치하지 않습니다"
        }

        XCTAssertTrue(passwordChangeUseCase.receivedRequests.isEmpty)
        XCTAssertFalse(store.state.isChangeSuccessful)
    }

    func testChangeButtonTapped_OnSuccess_MarksSuccessAndSendsRequest() async {
        let passwordChangeUseCase = PasswordChangeUseCaseSpy { _ in
            Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            passwordChangeUseCase: passwordChangeUseCase,
            initialState: state(
                newPassword: "Password1!",
                newPasswordCheck: "Password1!"
            )
        )

        await store.send(.changeButtonTapped)
        await store.receive(
            { action in
                if case .passwordChangeResponse(.success) = action {
                    return true
                }
                return false
            },
            assert: {
                $0.isChangeSuccessful = true
                $0.errorMessage = nil
            }
        )

        XCTAssertEqual(passwordChangeUseCase.receivedRequests.count, 1)
        XCTAssertEqual(passwordChangeUseCase.receivedRequests.first?.password, "Password1!")
        XCTAssertEqual(passwordChangeUseCase.receivedRequests.first?.adminId, "admin")
        XCTAssertEqual(passwordChangeUseCase.receivedRequests.first?.code, "123456")
    }

    private func makeStore(
        passwordChangeUseCase: any PasswordChangeUseCase = PasswordChangeUseCaseSpy(),
        initialState: NewPasswordReducer.State = .init()
    ) -> TestStore<NewPasswordReducer.State, NewPasswordReducer.Action> {
        TestStore(initialState: initialState) {
            NewPasswordReducer(
                passwordChangeUseCase: passwordChangeUseCase,
                accountId: "admin",
                code: "123456"
            )
        }
    }

    private func state(
        newPassword: String = "",
        newPasswordCheck: String = "",
        errorMessage: String? = nil
    ) -> NewPasswordReducer.State {
        var state = NewPasswordReducer.State()
        state.newPassword = newPassword
        state.newPasswordCheck = newPasswordCheck
        state.errorMessage = errorMessage
        return state
    }
}

private final class PasswordChangeUseCaseSpy: PasswordChangeUseCase {
    private let executeHandler: (PasswordChangeRequestParams) -> AnyPublisher<Void, Error>
    private(set) var receivedRequests: [PasswordChangeRequestParams] = []

    init(
        executeHandler: @escaping (PasswordChangeRequestParams) -> AnyPublisher<Void, Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(req: PasswordChangeRequestParams) -> AnyPublisher<Void, Error> {
        receivedRequests.append(req)
        return executeHandler(req)
    }
}
