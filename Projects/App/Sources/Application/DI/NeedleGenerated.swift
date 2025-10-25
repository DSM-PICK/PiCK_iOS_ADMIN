

import AuthDomain
import AuthDomainInterface
import BaseDomain
import ComposableArchitecture
import Core
import HomeFeature
import HomeFeatureInterface
import KeychainSwift
import Moya
import NeedleFoundation
import OnboardingFeature
import OnboardingFeatureInterface
import SigninFeature
import SigninFeatureInterface
import SignupFeature
import SignupFeatureInterface
import SwiftUI

// swiftlint:disable unused_declaration
private let needleDependenciesHash : String? = nil

// MARK: - Traversal Helpers

private func parent1(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class RootDependency3944cc797a4a88956fb5Provider: RootDependency {
    var onboardingFactory: any OnboardingFactory {
        return appComponent.onboardingFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->RootComponent
private func factory264bfc4d4cb6b0629b40f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return RootDependency3944cc797a4a88956fb5Provider(appComponent: parent1(component) as! AppComponent)
}
private class OnboardingDependencyf77d0055983a00cf8835Provider: OnboardingDependency {


    init() {

    }
}
/// ^->AppComponent->OnboardingComponent
private func factory88dc13cc29c5719e2b01e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return OnboardingDependencyf77d0055983a00cf8835Provider()
}
private class SignupDependency1ff7d1355204bb65e850Provider: SignupDependency {
    var loginUseCase: any LoginUseCase {
        return appComponent.loginUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->SignupComponent
private func factory86602ff0d0dbaf2cb017f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SignupDependency1ff7d1355204bb65e850Provider(appComponent: parent1(component) as! AppComponent)
}
private class SigninDependencyde06a9d0b22764487733Provider: SigninDependency {
    var loginUseCase: any LoginUseCase {
        return appComponent.loginUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->SigninComponent
private func factory2882a056d84a613debccf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SigninDependencyde06a9d0b22764487733Provider(appComponent: parent1(component) as! AppComponent)
}
private class HomeDependency443c4e1871277bd8432aProvider: HomeDependency {


    init() {

    }
}
/// ^->AppComponent->HomeComponent
private func factory67229cdf0f755562b2b1e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return HomeDependency443c4e1871277bd8432aProvider()
}

#else
extension AppComponent: NeedleFoundation.Registration {
    public func registerItems() {

        localTable["keychain-any Keychain"] = { [unowned self] in self.keychain as Any }
        localTable["signinFactory-any SigninFactory"] = { [unowned self] in self.signinFactory as Any }
        localTable["signupFactory-any SignupFactory"] = { [unowned self] in self.signupFactory as Any }
        localTable["onboardingFactory-any OnboardingFactory"] = { [unowned self] in self.onboardingFactory as Any }
        localTable["homeFactory-any HomeFactory"] = { [unowned self] in self.homeFactory as Any }
        localTable["userDefault-any UserDefault"] = { [unowned self] in self.userDefault as Any }
        localTable["authProvider-MoyaProvider<AuthAPI>"] = { [unowned self] in self.authProvider as Any }
        localTable["localAuthDataSource-any LocalAuthDataSource"] = { [unowned self] in self.localAuthDataSource as Any }
        localTable["remoteAuthDataSource-any RemoteAuthDataSource"] = { [unowned self] in self.remoteAuthDataSource as Any }
        localTable["authRepository-any AuthRepository"] = { [unowned self] in self.authRepository as Any }
        localTable["loginUseCase-any LoginUseCase"] = { [unowned self] in self.loginUseCase as Any }
        localTable["refreshTokenUseCase-any RefreshTokenUseCase"] = { [unowned self] in self.refreshTokenUseCase as Any }
    }
}
extension RootComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\RootDependency.onboardingFactory] = "onboardingFactory-any OnboardingFactory"
    }
}
extension OnboardingComponent: NeedleFoundation.Registration {
    public func registerItems() {

    }
}
extension SignupComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\SignupDependency.loginUseCase] = "loginUseCase-any LoginUseCase"
    }
}
extension SigninComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\SigninDependency.loginUseCase] = "loginUseCase-any LoginUseCase"
    }
}
extension HomeComponent: NeedleFoundation.Registration {
    public func registerItems() {

    }
}


#endif

private func factoryEmptyDependencyProvider(_ component: NeedleFoundation.Scope) -> AnyObject {
    return EmptyDependencyProvider(component: component)
}

// MARK: - Registration
private func registerProviderFactory(_ componentPath: String, _ factory: @escaping (NeedleFoundation.Scope) -> AnyObject) {
    __DependencyProviderRegistry.instance.registerDependencyProviderFactory(for: componentPath, factory)
}

#if !NEEDLE_DYNAMIC

@inline(never) private func register1() {
    registerProviderFactory("^->AppComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->RootComponent", factory264bfc4d4cb6b0629b40f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->OnboardingComponent", factory88dc13cc29c5719e2b01e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->SignupComponent", factory86602ff0d0dbaf2cb017f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SigninComponent", factory2882a056d84a613debccf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->HomeComponent", factory67229cdf0f755562b2b1e3b0c44298fc1c149afb)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
