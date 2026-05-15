import XCTest
import Combine
import ComposableArchitecture
import AllTabDomainInterface
import AuthDomainInterface
@testable import AllTabFeature

@MainActor
final class AllTabFeatureTests: XCTestCase {
    func testFetchMyNameSuccess_StoresFetchedTeacher() async {
        let expectedTeacher = MyNameEntity(name: "김선생", grade: 2, classNum: 3)
        let store = makeStore(
            getMyNameUseCase: GetMyNameUseCaseSpy {
                Just(expectedTeacher)
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )

        await store.send(.fetchMyName)
        await store.receive(
            {
                if case let .myNameResponse(.success(teacher)) = $0 {
                    return teacher == expectedTeacher
                }
                return false
            },
            assert: {
                $0.myName = expectedTeacher
            }
        )
    }

    func testLogoutButtonTapped_LogsOutAndSetsNavigationFlag() async {
        let authRepository = AuthRepositorySpy()
        let store = makeStore(authRepository: authRepository)

        await store.send(.logoutButtonTapped) {
            $0.shouldLogout = true
        }

        XCTAssertEqual(authRepository.logoutCallCount, 1)
    }

    func testConfirmResignSuccess_SetsResignFlag() async {
        let authRepository = AuthRepositorySpy(
            resignHandler: {
                Just(())
                    .setFailureType(to: Error.self)
                    .eraseToAnyPublisher()
            }
        )
        let store = makeStore(authRepository: authRepository)

        await store.send(.confirmResign)
        await store.receive(
            {
                if case .resignResponse(.success(())) = $0 {
                    return true
                }
                return false
            },
            assert: {
                $0.shouldResign = true
            }
        )

        XCTAssertEqual(authRepository.resignCallCount, 1)
    }

    private func makeStore(
        getMyNameUseCase: any GetMyNameUseCaseProtocol = GetMyNameUseCaseSpy(),
        authRepository: AuthRepositorySpy = AuthRepositorySpy()
    ) -> TestStore<AllTabReducer.State, AllTabReducer.Action> {
        TestStore(initialState: AllTabReducer.State()) {
            AllTabReducer(
                getMyNameUseCase: getMyNameUseCase,
                authRepository: authRepository
            )
        }
    }
}

private final class GetMyNameUseCaseSpy: GetMyNameUseCaseProtocol {
    private let executeHandler: () -> AnyPublisher<MyNameEntity, Error>

    init(
        executeHandler: @escaping () -> AnyPublisher<MyNameEntity, Error> = {
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.executeHandler = executeHandler
    }

    func execute() -> AnyPublisher<MyNameEntity, Error> {
        executeHandler()
    }
}

private final class AuthRepositorySpy: AuthRepository {
    private let resignHandler: () -> AnyPublisher<Void, Error>
    private(set) var logoutCallCount = 0
    private(set) var resignCallCount = 0

    init(
        resignHandler: @escaping () -> AnyPublisher<Void, Error> = {
            Empty(completeImmediately: true)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }
    ) {
        self.resignHandler = resignHandler
    }

    func signin(req: SigninRequestParams) -> AnyPublisher<Void, Error> {
        Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func secretKey(req: SecretKeyRequestParams) -> AnyPublisher<Bool, Error> {
        Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func signup(req: SignupRequestParams) -> AnyPublisher<Void, Error> {
        Empty(completeImmediately: true)
            .setFailureType(to: Error.self)
            .eraseToAnyPublisher()
    }

    func logout() {
        logoutCallCount += 1
    }

    func resign() -> AnyPublisher<Void, Error> {
        resignCallCount += 1
        return resignHandler()
    }
}
