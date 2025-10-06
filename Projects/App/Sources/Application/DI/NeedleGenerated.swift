

import AuthDomain
import AuthDomainInterface
import AuthFeature
import AuthFeatureInterface
import ComposableArchitecture
import Core
import KeychainSwift
import Moya
import NeedleFoundation
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
    var authFactory: any AuthFactory {
        return appComponent.authFactory
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
private class AuthDependency66debf38ba68676d3271Provider: AuthDependency {
    var loginUseCase: any LoginUseCase {
        return appComponent.loginUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->AuthComponent
private func factorybe7a1f90226e27d1b2e4f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return AuthDependency66debf38ba68676d3271Provider(appComponent: parent1(component) as! AppComponent)
}

#else
extension AppComponent: NeedleFoundation.Registration {
    public func registerItems() {

        localTable["keychain-any Keychain"] = { [unowned self] in self.keychain as Any }
        localTable["authProvider-MoyaProvider<AuthAPI>"] = { [unowned self] in self.authProvider as Any }
        localTable["localAuthDataSource-any LocalAuthDataSource"] = { [unowned self] in self.localAuthDataSource as Any }
        localTable["remoteAuthDataSource-any RemoteAuthDataSource"] = { [unowned self] in self.remoteAuthDataSource as Any }
        localTable["authRepository-any AuthRepository"] = { [unowned self] in self.authRepository as Any }
        localTable["loginUseCase-any LoginUseCase"] = { [unowned self] in self.loginUseCase as Any }
        localTable["refreshTokenUseCase-any RefreshTokenUseCase"] = { [unowned self] in self.refreshTokenUseCase as Any }
        localTable["authFactory-any AuthFactory"] = { [unowned self] in self.authFactory as Any }
        localTable["userDefault-any UserDefault"] = { [unowned self] in self.userDefault as Any }
    }
}
extension RootComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\RootDependency.authFactory] = "authFactory-any AuthFactory"
    }
}
extension AuthComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\AuthDependency.loginUseCase] = "loginUseCase-any LoginUseCase"
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
    registerProviderFactory("^->AppComponent->AuthComponent", factorybe7a1f90226e27d1b2e4f47b58f8f304c97af4d5)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
