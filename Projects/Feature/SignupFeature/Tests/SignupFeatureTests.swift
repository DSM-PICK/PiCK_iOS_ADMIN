import XCTest
import ComposableArchitecture
@testable import SignupFeature

@MainActor
final class SignupFeatureTests: XCTestCase {
    func testPasswordBinding_UpdatesState() async {
        let store = makeStore()

        await store.send(
            .binding(BindingAction<PasswordReducer.State>.allCasePaths.password.embed("Abcd1234!"))
        ) {
            $0.password = "Abcd1234!"
        }
    }

    func testPasswordConfirmBinding_UpdatesState() async {
        let store = makeStore()

        await store.send(
            .binding(
                BindingAction<PasswordReducer.State>.allCasePaths.passwordConfirm.embed("Abcd1234!")
            )
        ) {
            $0.passwordConfirm = "Abcd1234!"
        }
    }

    func testNextButtonTapped_WhenPasswordsDoNotMatch_ShowsError() async {
        let store = makeStore(initialState: state(password: "Abcd1234!", passwordConfirm: "Abcd1234?"))

        await store.send(.nextButtonTapped) {
            $0.errorMessage = "비밀번호 일치하지 않습니다"
        }
    }

    func testNextButtonTapped_WhenPasswordFormatInvalid_ShowsError() async {
        let store = makeStore(initialState: state(password: "short", passwordConfirm: "short"))

        await store.send(.nextButtonTapped) {
            $0.errorMessage = "8~30자 영문자, 숫자, 특수문자 포함하세요"
        }
    }

    func testNextButtonTapped_WhenPasswordValid_MarksSuccess() async {
        let store = makeStore(initialState: state(password: "Abcd1234!", passwordConfirm: "Abcd1234!"))

        await store.send(.nextButtonTapped) {
            $0.isSuccessful = true
        }
    }

    private func makeStore(
        initialState: PasswordReducer.State = .init()
    ) -> TestStore<PasswordReducer.State, PasswordReducer.Action> {
        TestStore(initialState: initialState) {
            PasswordReducer()
        }
    }

    private func state(
        password: String = "",
        passwordConfirm: String = ""
    ) -> PasswordReducer.State {
        var state = PasswordReducer.State()
        state.password = password
        state.passwordConfirm = passwordConfirm
        return state
    }
}
