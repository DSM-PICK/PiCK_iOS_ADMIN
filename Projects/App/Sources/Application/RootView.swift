import SwiftUI
import ComposableArchitecture
import OnboardingFeature
import OnboardingFeatureInterface
import SigninFeature
import SigninFeatureInterface
import HomeFeatureInterface
import BaseDomain
import Utility

struct RootView: View {
    @StateObject var router = AppRouter()
    let appComponent: AppComponent
    @State private var isCheckingAuth = true

    var body: some View {
        Group {
            if isCheckingAuth {
                authLoadingView
            } else if router.path.last == .home {
                homeView
            } else {
                navigationStackView
            }
        }
        .onAppear(perform: checkAuthStatus)
    }
    
    private var authLoadingView: some View {
        VStack {
            ProgressView()
                .progressViewStyle(CircularProgressViewStyle())
        }
    }
    
    private var homeView: some View {
        appComponent.homeFactory.makeView()
            .environmentObject(router)
    }
    
    private var navigationStackView: some View {
        NavigationStack(path: $router.path) {
            appComponent.onboardingFactory.makeView()
                .environmentObject(router)
                .navigationDestination(for: AppRoute.self) { route in
                    routeDestination(for: route)
                }
        }
    }
    
    @ViewBuilder
    private func routeDestination(for route: AppRoute) -> some View {
        switch route {
        case .onboarding:
            appComponent.onboardingFactory.makeView()
                .environmentObject(router)
        case .signin:
            appComponent.signinFactory.makeView()
                .environmentObject(router)
        case .secretKey:
            appComponent.secretKeyFactory.makeView()
                .environmentObject(router)
        case let .email(secretKey):
            appComponent.verifyEmailFactory.makeView(secretKey: secretKey)
                .environmentObject(router)
        case let .password(secretKey, accountId, code):
            appComponent.passwordFactory.makeView(secretKey: secretKey, accountId: accountId, code: code)
                .environmentObject(router)
        case let .infoSetting(secretKey, accountId, code, password):
            appComponent.infoSettingFactory.makeView(secretKey: secretKey, accountId: accountId, code: code, password: password)
                .environmentObject(router)
        case .home:
            EmptyView()
        }
    }
    
    private func checkAuthStatus() {
        if JwtStore.shared.hasValidToken {
            router.path = [.home]
        }
        isCheckingAuth = false
    }
}
