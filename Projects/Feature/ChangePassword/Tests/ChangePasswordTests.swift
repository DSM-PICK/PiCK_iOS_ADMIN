import XCTest
import Combine
import ComposableArchitecture
import AuthDomainInterface
@testable import ChangePasswordFeature

@MainActor
final class ChangePasswordTests: XCTestCase {
    func testEmailBinding_UpdatesEmailAndClearsError() async {
        let store = makeStore(initialState: state(errorMessage: "old error"))

        await store.send(\.binding.email, "pick@dsm.hs.kr") {
            $0.email = "pick@dsm.hs.kr"
            $0.errorMessage = nil
        }
    }

    func testCodeBinding_UpdatesCodeAndClearsError() async {
        let store = makeStore(initialState: state(errorMessage: "old error"))

        await store.send(\.binding.code, "123456") {
            $0.code = "123456"
            $0.errorMessage = nil
        }
    }

    func testVerificationButtonTapped_WithEmptyEmail_SetsValidationError() async {
        let emailSendUseCase = EmailSendUseCaseSpy()
        let codeCheckUseCase = CodeCheckUseCaseSpy()
        let store = makeStore(
            emailSendUseCase: emailSendUseCase,
            codeCheckUseCase: codeCheckUseCase
        )

        await store.send(ChangePasswordReducer.Action.verificationButtonTapped) {
            $0.errorMessage = "이메일을 입력해주세요"
        }

        XCTAssertFalse(store.state.isVerificationSent)
        XCTAssertTrue(emailSendUseCase.receivedRequests.isEmpty)
        XCTAssertTrue(codeCheckUseCase.receivedRequests.isEmpty)
    }

    func testNextButtonTapped_WithEmptyField_SetsValidationError() async {
        let emailSendUseCase = EmailSendUseCaseSpy()
        let codeCheckUseCase = CodeCheckUseCaseSpy()
        var initialState = ChangePasswordReducer.State()
        initialState.email = "pick@dsm.hs.kr"
        let store = makeStore(
            emailSendUseCase: emailSendUseCase,
            codeCheckUseCase: codeCheckUseCase,
            initialState: initialState
        )

        await store.send(ChangePasswordReducer.Action.nextButtonTapped) {
            $0.errorMessage = "모든 필드를 입력해주세요"
        }

        XCTAssertNil(store.state.accountId)
        XCTAssertTrue(codeCheckUseCase.receivedRequests.isEmpty)
    }

    func testVerificationButtonTapped_OnSuccess_SetsVerificationSuccessState() async {
        let emailSendUseCase = EmailSendUseCaseSpy { _ in
            Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let codeCheckUseCase = CodeCheckUseCaseSpy()
        var initialState = ChangePasswordReducer.State()
        initialState.email = "pick@dsm.hs.kr"
        initialState.errorMessage = "old error"
        let store = makeStore(
            emailSendUseCase: emailSendUseCase,
            codeCheckUseCase: codeCheckUseCase,
            initialState: initialState
        )

        await store.send(ChangePasswordReducer.Action.verificationButtonTapped)
        await store.receive(
            {
                if case .emailSendResponse(.success) = $0 {
                    return true
                }
                return false
            },
            assert: {
                $0.isVerificationSent = true
                $0.errorMessage = nil
                $0.successMessage = "이메일로 코드가 전송되었어요!"
            }
        )

        XCTAssertEqual(emailSendUseCase.receivedRequests.count, 1)
        XCTAssertEqual(emailSendUseCase.receivedRequests.first?.mail, "pick@dsm.hs.kr")
        XCTAssertEqual(emailSendUseCase.receivedRequests.first?.title, "비밀번호 변경 인증")
        XCTAssertEqual(emailSendUseCase.receivedRequests.first?.message, "비밀번호 변경 인증")
    }

    func testVerificationButtonTapped_OnFailure_PropagatesErrorMessage() async {
        let emailSendUseCase = EmailSendUseCaseSpy { _ in
            Fail(error: TestError("send failed"))
                .eraseToAnyPublisher()
        }
        let codeCheckUseCase = CodeCheckUseCaseSpy()
        var initialState = ChangePasswordReducer.State()
        initialState.email = "pick@dsm.hs.kr"
        let store = makeStore(
            emailSendUseCase: emailSendUseCase,
            codeCheckUseCase: codeCheckUseCase,
            initialState: initialState
        )

        await store.send(ChangePasswordReducer.Action.verificationButtonTapped)
        await store.receive(
            {
                if case let .emailSendResponse(.failure(error)) = $0 {
                    return error.localizedDescription == "send failed"
                }
                return false
            },
            assert: {
                $0.errorMessage = "send failed"
                $0.successMessage = nil
            }
        )

        XCTAssertFalse(store.state.isVerificationSent)
    }

    func testNextButtonTapped_WithInvalidCode_SetsExpectedError() async {
        let emailSendUseCase = EmailSendUseCaseSpy()
        let codeCheckUseCase = CodeCheckUseCaseSpy { _ in
            Just(false)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        var initialState = ChangePasswordReducer.State()
        initialState.email = "pick@dsm.hs.kr"
        initialState.code = "123456"
        let store = makeStore(
            emailSendUseCase: emailSendUseCase,
            codeCheckUseCase: codeCheckUseCase,
            initialState: initialState
        )

        await store.send(ChangePasswordReducer.Action.nextButtonTapped)
        await store.receive(
            {
                if case .codeCheckResponse(.success(false)) = $0 {
                    return true
                }
                return false
            },
            assert: {
                $0.errorMessage = "인증코드가 올바르지 않습니다"
            }
        )

        XCTAssertEqual(codeCheckUseCase.receivedRequests.count, 1)
        XCTAssertEqual(codeCheckUseCase.receivedRequests.first?.email, "pick@dsm.hs.kr")
        XCTAssertEqual(codeCheckUseCase.receivedRequests.first?.code, "123456")
        XCTAssertNil(store.state.accountId)
    }

    func testNextButtonTapped_OnSuccessfulCodeCheck_SetsAccountId() async {
        let emailSendUseCase = EmailSendUseCaseSpy()
        let codeCheckUseCase = CodeCheckUseCaseSpy { _ in
            Just(true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        var initialState = ChangePasswordReducer.State()
        initialState.email = "pick@dsm.hs.kr"
        initialState.code = "123456"
        initialState.errorMessage = "old error"
        let store = makeStore(
            emailSendUseCase: emailSendUseCase,
            codeCheckUseCase: codeCheckUseCase,
            initialState: initialState
        )

        await store.send(ChangePasswordReducer.Action.nextButtonTapped)
        await store.receive(
            {
                if case .codeCheckResponse(.success(true)) = $0 {
                    return true
                }
                return false
            },
            assert: {
                $0.accountId = "pick@dsm.hs.kr"
                $0.errorMessage = nil
            }
        )
    }

    func testNextButtonTapped_OnCodeCheckFailure_PropagatesErrorMessage() async {
        let emailSendUseCase = EmailSendUseCaseSpy()
        let codeCheckUseCase = CodeCheckUseCaseSpy { _ in
            Fail(error: TestError("check failed"))
                .eraseToAnyPublisher()
        }
        var initialState = ChangePasswordReducer.State()
        initialState.email = "pick@dsm.hs.kr"
        initialState.code = "123456"
        let store = makeStore(
            emailSendUseCase: emailSendUseCase,
            codeCheckUseCase: codeCheckUseCase,
            initialState: initialState
        )

        await store.send(ChangePasswordReducer.Action.nextButtonTapped)
        await store.receive(
            {
                if case let .codeCheckResponse(.failure(error)) = $0 {
                    return error.localizedDescription == "check failed"
                }
                return false
            },
            assert: {
                $0.errorMessage = "check failed"
            }
        )

        XCTAssertNil(store.state.accountId)
    }

    private func makeStore(
        initialState: ChangePasswordReducer.State = .init()
    ) -> TestStore<ChangePasswordReducer.State, ChangePasswordReducer.Action> {
        makeStore(
            emailSendUseCase: EmailSendUseCaseSpy(),
            codeCheckUseCase: CodeCheckUseCaseSpy(),
            initialState: initialState
        )
    }

    private func makeStore(
        emailSendUseCase: any EmailSendUseCase,
        codeCheckUseCase: any CodeCheckUseCase,
        initialState: ChangePasswordReducer.State = .init()
    ) -> TestStore<ChangePasswordReducer.State, ChangePasswordReducer.Action> {
        TestStore(initialState: initialState) {
            ChangePasswordReducer(
                emailSendUseCase: emailSendUseCase,
                codeCheckUseCase: codeCheckUseCase
            )
        }
    }

    private func state(
        email: String = "",
        code: String = "",
        errorMessage: String? = nil
    ) -> ChangePasswordReducer.State {
        var state = ChangePasswordReducer.State()
        state.email = email
        state.code = code
        state.errorMessage = errorMessage
        return state
    }

}

private final class EmailSendUseCaseSpy: EmailSendUseCase {
    private let executeHandler: (EmailSendRequestParams) -> AnyPublisher<Void, Error>
    private(set) var receivedRequests: [EmailSendRequestParams] = []

    init(
        executeHandler: @escaping (EmailSendRequestParams) -> AnyPublisher<Void, Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(req: EmailSendRequestParams) -> AnyPublisher<Void, Error> {
        receivedRequests.append(req)
        return executeHandler(req)
    }
}

private final class CodeCheckUseCaseSpy: CodeCheckUseCase {
    private let executeHandler: (CodeCheckRequestParams) -> AnyPublisher<Bool, Error>
    private(set) var receivedRequests: [CodeCheckRequestParams] = []

    init(
        executeHandler: @escaping (CodeCheckRequestParams) -> AnyPublisher<Bool, Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(req: CodeCheckRequestParams) -> AnyPublisher<Bool, Error> {
        receivedRequests.append(req)
        return executeHandler(req)
    }
}

private struct TestError: LocalizedError {
    let message: String

    init(_ message: String) {
        self.message = message
    }

    var errorDescription: String? {
        message
    }
}
