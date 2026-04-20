import Combine
import ComposableArchitecture
import AuthDomainInterface
import XCTest
@testable import SignupFeature

@MainActor
final class SignupLegacySubflowTests: XCTestCase {
    func testInfoSettingNameBinding_UpdatesState() async {
        let store = makeInfoSettingStore()

        await store.send(
            .binding(BindingAction<InfoSettingReducer.State>.allCasePaths.name.embed("홍길동"))
        ) {
            $0.name = "홍길동"
        }
    }

    func testInfoSettingFinishButtonTapped_WhenSignupSucceeds_MarksSuccess() async {
        let useCase = SignupUseCaseSpy { _ in
            Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeInfoSettingStore(
            useCase: useCase,
            initialState: {
                var state = InfoSettingReducer.State(
                    secretKey: "secret",
                    accountId: "teacher@dsm.hs.kr",
                    code: "123456",
                    password: "Abcd1234!"
                )
                state.name = "홍길동"
                state.selectedGrade = 2
                state.selectedClass = 3
                return state
            }()
        )

        await store.send(.finishButtonTapped)
        await store.receive(
            {
                if case .signupResponse(.success(())) = $0 {
                    return true
                }
                return false
            },
            assert: {
                $0.isSignupSuccessful = true
            }
        )

        XCTAssertEqual(useCase.receivedRequests.count, 1)
        XCTAssertEqual(useCase.receivedRequests.first?.name, "홍길동")
    }

    func testSecretKeyBinding_UpdatesState() async {
        let store = makeSecretKeyStore()

        await store.send(
            .binding(BindingAction<SecretKeyReducer.State>.allCasePaths.secretKey.embed("key-1234"))
        ) {
            $0.secretKey = "key-1234"
        }
    }

    func testSecretKeyNextButtonTapped_WhenUseCaseReturnsFalse_ShowsError() async {
        let useCase = SecretKeyUseCaseSpy { _ in
            Just(false)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeSecretKeyStore(
            useCase: useCase,
            initialState: {
                var state = SecretKeyReducer.State()
                state.secretKey = "wrong-key"
                return state
            }()
        )

        await store.send(.nextButtonTapped)
        await store.receive(
            {
                if case .secretKeyResponse(.success(false)) = $0 {
                    return true
                }
                return false
            },
            assert: {
                $0.isSigninSuccessful = false
                $0.errorMessage = "올바른 시크릿 키를 입력해주세요"
            }
        )
    }

    func testVerifyEmailBinding_UpdatesState() async {
        let store = makeVerifyEmailStore(secretKey: "secret")

        await store.send(
            .binding(BindingAction<VerifyEmailReducer.State>.allCasePaths.email.embed("teacher@dsm.hs.kr"))
        ) {
            $0.email = "teacher@dsm.hs.kr"
        }
        await store.send(
            .binding(BindingAction<VerifyEmailReducer.State>.allCasePaths.code.embed("123456"))
        ) {
            $0.code = "123456"
        }
    }

    func testVerifyEmailVerificationButtonTapped_WhenSendSucceeds_ReceivesSuccess() async {
        let emailSendUseCase = EmailSendUseCaseSpy { _ in
            Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeVerifyEmailStore(
            secretKey: "secret",
            emailSendUseCase: emailSendUseCase,
            initialState: {
                var state = VerifyEmailReducer.State(secretKey: "secret")
                state.email = "teacher@dsm.hs.kr"
                return state
            }()
        )

        await store.send(.verificationButtonTapped)
        await store.receive(
            {
                if case .emailSendResponse(.success(())) = $0 {
                    return true
                }
                return false
            }
        )

        XCTAssertEqual(emailSendUseCase.receivedRequests.first?.mail, "teacher@dsm.hs.kr")
    }

    func testVerifyEmailNextButtonTapped_WhenCodeCheckSucceeds_MarksSuccess() async {
        let codeCheckUseCase = CodeCheckUseCaseSpy { _ in
            Just(true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeVerifyEmailStore(
            secretKey: "secret",
            codeCheckUseCase: codeCheckUseCase,
            initialState: {
                var state = VerifyEmailReducer.State(secretKey: "secret")
                state.email = "teacher@dsm.hs.kr"
                state.code = "123456"
                return state
            }()
        )

        await store.send(.nextButtonTapped)
        await store.receive(
            {
                if case .codeCheckResponse(.success(true)) = $0 {
                    return true
                }
                return false
            },
            assert: {
                $0.isSuccessful = true
            }
        )
    }
}

private extension SignupLegacySubflowTests {
    func makeInfoSettingStore(
        useCase: any SignupUseCase = SignupUseCaseSpy(),
        initialState: InfoSettingReducer.State = .init()
    ) -> TestStore<InfoSettingReducer.State, InfoSettingReducer.Action> {
        TestStore(initialState: initialState) {
            InfoSettingReducer(signupUseCase: useCase)
        }
    }

    func makeSecretKeyStore(
        useCase: any SecretKeyUseCase = SecretKeyUseCaseSpy(),
        initialState: SecretKeyReducer.State = .init()
    ) -> TestStore<SecretKeyReducer.State, SecretKeyReducer.Action> {
        TestStore(initialState: initialState) {
            SecretKeyReducer(secretKeyUseCase: useCase)
        }
    }

    func makeVerifyEmailStore(
        secretKey: String,
        emailSendUseCase: any EmailSendUseCase = EmailSendUseCaseSpy(),
        codeCheckUseCase: any CodeCheckUseCase = CodeCheckUseCaseSpy(),
        initialState: VerifyEmailReducer.State? = nil
    ) -> TestStore<VerifyEmailReducer.State, VerifyEmailReducer.Action> {
        TestStore(initialState: initialState ?? .init(secretKey: secretKey)) {
            VerifyEmailReducer(
                emailSendUseCase: emailSendUseCase,
                codeCheckUseCase: codeCheckUseCase
            )
        }
    }
}

private final class SignupUseCaseSpy: SignupUseCase {
    private let executeHandler: (SignupRequestParams) -> AnyPublisher<Void, Error>
    private(set) var receivedRequests: [SignupRequestParams] = []

    init(
        executeHandler: @escaping (SignupRequestParams) -> AnyPublisher<Void, Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(req: SignupRequestParams) -> AnyPublisher<Void, Error> {
        receivedRequests.append(req)
        return executeHandler(req)
    }
}

private final class SecretKeyUseCaseSpy: SecretKeyUseCase {
    private let executeHandler: (SecretKeyRequestParams) -> AnyPublisher<Bool, Error>
    private(set) var receivedRequests: [SecretKeyRequestParams] = []

    init(
        executeHandler: @escaping (SecretKeyRequestParams) -> AnyPublisher<Bool, Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(req: SecretKeyRequestParams) -> AnyPublisher<Bool, Error> {
        receivedRequests.append(req)
        return executeHandler(req)
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
