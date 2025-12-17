import SwiftUI
import ComposableArchitecture
import OnboardingFeature
import OnboardingFeatureInterface
import SigninFeature
import SigninFeatureInterface
import HomeFeatureInterface
import ChangePasswordFeature
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
        ZStack {
            if router.path.isEmpty {
                appComponent.onboardingFactory.makeView()
                    .environmentObject(router)
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
                    .zIndex(0)
            }

            if !router.path.isEmpty {
                NavigationStack(path: $router.path) {
                    Color.clear
                        .navigationDestination(for: AppRoute.self) { route in
                            routeDestination(for: route)
                        }
                }
                .transition(.asymmetric(
                    insertion: AnyTransition.offset(x: 0, y: 20).combined(with: .opacity),
                    removal: .opacity.combined(with: .scale(scale: 1.05))
                ))
                .zIndex(1)
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: router.path.count)
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
        case .outList:
            appComponent.outListFactory.makeView()
                .environmentObject(router)
        case .checkSelfStudyTeacher:
            appComponent.checkSelfStudyTeacherFactory.makeView()
                .environmentObject(router)
        case .bugReport:
            appComponent.bugReportFactory.makeView()
                .environmentObject(router)
        case .changePassword:
            appComponent.changePasswordFactory.makeView()
                .environmentObject(router)
        case let .newPassword(accountId, code):
            appComponent.newPasswordFactory.makeView(accountId: accountId, code: code)
                .environmentObject(router)
        case .selfStudyCheck:
            appComponent.selfStudyCheckFactory.makeView()
        case .classroomMoveList:
            appComponent.classroomMoveListFactory.makeView()
                .environmentObject(router)
        case .outingHistory:
            appComponent.outingHistoryFactory.makeView()
                .environmentObject(router)
        }
    }
    
    private func checkAuthStatus() {
        if JwtStore.shared.hasValidToken {
            router.path = [.home]
        }
        isCheckingAuth = false
    }
}
