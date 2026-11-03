import ComposableArchitecture
import AuthDomainInterface
import Core
import Combine
import XCTest
import enum Utility.AnalyticsService
import protocol Utility.AnalyticsLogging
@testable import SigninFeature

@MainActor
final class SigninFeatureTests: XCTestCase {
    override func tearDown() {
        super.tearDown()
        UserDefaultStorage.shared.remove(forKey: .deviceToken)
    }

    func testEmailBinding_UpdatesState() async {
        let store = makeStore()

        await store.send(
            .binding(BindingAction<SigninReducer.State>.allCasePaths.email.embed("teacher@dsm.hs.kr"))
        ) {
            $0.email = "teacher@dsm.hs.kr"
        }
    }

    func testPasswordBinding_UpdatesState() async {
        let store = makeStore()

        await store.send(
            .binding(BindingAction<SigninReducer.State>.allCasePaths.password.embed("Abcd1234!"))
        ) {
            $0.password = "Abcd1234!"
        }
    }

    func testSigninButtonTapped_WhenUseCaseSucceeds_MarksSuccess() async {
        UserDefaultStorage.shared.set(to: "device-token", forKey: .deviceToken)
        let useCase = SigninUseCaseSpy { _ in
            Just(())
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            useCase: useCase,
            initialState: {
                var state = SigninReducer.State()
                state.email = "teacher@dsm.hs.kr"
                state.password = "Abcd1234!"
                return state
            }()
        )

        await store.send(.signinButtonTapped) {
            $0.isLoading = true
        }
        await store.receive(
            {
                if case .signinResponse(.success(())) = $0 {
                    return true
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.isSigninSuccessful = true
            }
        )

        XCTAssertEqual(useCase.receivedRequests.first?.adminID, "teacher@dsm.hs.kr")
        XCTAssertEqual(useCase.receivedRequests.first?.password, "Abcd1234!")
        XCTAssertEqual(useCase.receivedRequests.first?.deviceToken, "device-token")
    }

    func testSigninButtonTapped_WhenUseCaseFails_StoresError() async {
        let error = PiCKError.error(message: "로그인 실패")
        let useCase = SigninUseCaseSpy { _ in
            Fail(error: error)
                .eraseToAnyPublisher()
        }
        let store = makeStore(
            useCase: useCase,
            initialState: {
                var state = SigninReducer.State()
                state.email = "teacher@dsm.hs.kr"
                state.password = "wrong"
                return state
            }()
        )

        await store.send(.signinButtonTapped) {
            $0.isLoading = true
        }
        await store.receive(
            {
                if case let .signinResponse(.failure(error)) = $0 {
                    return error.localizedDescription == "로그인 실패"
                }
                return false
            },
            assert: {
                $0.isLoading = false
                $0.errorMessage = "로그인 실패"
            }
        )
    }

    private func makeStore(
        useCase: any SigninUseCase = SigninUseCaseSpy(),
        initialState: SigninReducer.State = .init()
    ) -> TestStore<SigninReducer.State, SigninReducer.Action> {
        TestStore(initialState: initialState) {
            SigninReducer(signinUseCase: useCase)
        }
    }

    func testSigninResponseSuccess_LogsLoginEvent() async {
        let analytics = AnalyticsLoggerSpy()
        AnalyticsService.configure(logger: analytics)
        addTeardownBlock { AnalyticsService.configure(logger: nil) }
        let store = makeStore()
        store.exhaustivity = .off

        await store.send(.signinResponse(.success(())))

        XCTAssertEqual(analytics.events, [.init(name: "login", parameters: ["method": "id_password"])])
    }

    func testSigninResponseFailure_DoesNotLogLoginEvent() async {
        let analytics = AnalyticsLoggerSpy()
        AnalyticsService.configure(logger: analytics)
        addTeardownBlock { AnalyticsService.configure(logger: nil) }
        let store = makeStore()
        store.exhaustivity = .off

        await store.send(.signinResponse(.failure(PiCKError.error(message: "로그인 실패"))))

        XCTAssertTrue(analytics.events.isEmpty)
    }
}

private final class SigninUseCaseSpy: SigninUseCase {
    private let executeHandler: (SigninRequestParams) -> AnyPublisher<Void, Error>
    private(set) var receivedRequests: [SigninRequestParams] = []

    init(
        executeHandler: @escaping (SigninRequestParams) -> AnyPublisher<Void, Error> = { _ in
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute(req: SigninRequestParams) -> AnyPublisher<Void, Error> {
        receivedRequests.append(req)
        return executeHandler(req)
    }
}

private final class AnalyticsLoggerSpy: AnalyticsLogging {
    struct LoggedEvent: Equatable {
        let name: String
        let parameters: [String: String]
    }

    private(set) var events: [LoggedEvent] = []

    func logEvent(_ name: String, parameters: [String: Any]?) {
        events.append(LoggedEvent(
            name: name,
            parameters: parameters?.compactMapValues { $0 as? String } ?? [:]
        ))
    }
}
