
import SwiftUI
import ComposableArchitecture
import OnboardingFeature
import OnboardingFeatureInterface
import SigninFeature
import SigninFeatureInterface
import Utility


struct RootView: View {
    @StateObject var router = AppRouter()
    let appComponent: AppComponent

    var body: some View {
        NavigationStack(path: $router.path) {
            appComponent.onboardingFactory.makeView()
            .environmentObject(router)
            .navigationDestination(for: AppRoute.self) { route in
                switch route {
                case .onboarding:
                    appComponent.onboardingFactory.makeView()
                        .environmentObject(router)
                case .signin:
                    appComponent.signinFactory.makeView()
                        .environmentObject(router)
                }
            }
        }
    }
}
