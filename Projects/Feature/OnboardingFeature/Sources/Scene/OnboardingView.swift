import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

struct OnboardingView: View {
    @Perception.Bindable var store: StoreOf<OnboardingReducer>
    @EnvironmentObject var router: AppRouter

    public init(store: StoreOf<OnboardingReducer>) {
        self.store = store
    }

    var body: some View {
        WithPerceptionTracking {
            VStack {
                Spacer()

                PiCKImage.adminLogo

                Spacer()

                PiCKButton(
                    buttonText: "로그인",
                    action: {
                        store.send(.loginButtonTapped)
                    }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
            }
            .onChange(of: store.shouldNavigateToSignin) { shouldNavigateToSignin in
                guard shouldNavigateToSignin else { return }

                withAnimation(.easeOut(duration: 0.35)) {
                    router.path.append(.signin)
                }
                store.send(.signinNavigationHandled)
            }
        }
    }
}
