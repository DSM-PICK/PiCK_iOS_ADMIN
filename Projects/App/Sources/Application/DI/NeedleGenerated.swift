

import AcceptDomain
import AcceptDomainInterface
import AcceptFeature
import AcceptFeatureInterface
import AllTabDomain
import AllTabDomainInterface
import AllTabFeature
import AllTabFeatureInterface
import AuthDomain
import AuthDomainInterface
import BaseDomain
import ComposableArchitecture
import Core
import Foundation
import HomeDomain
import HomeDomainInterface
import HomeFeature
import HomeFeatureInterface
import KeychainSwift
import Moya
import NeedleFoundation
import OnboardingFeature
import OnboardingFeatureInterface
import PlanDomain
import PlanDomainInterface
import PlanFeature
import PlanFeatureInterface
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

private class PlanDependency0acb045bed3f80b42d39Provider: PlanDependency {
    var fetchAcademicScheduleUseCase: any FetchAcademicScheduleUseCaseProtocol {
        return appComponent.fetchAcademicScheduleUseCase
    }
    var fetchMonthAcademicScheduleUseCase: any FetchMonthAcademicScheduleUseCaseProtocol {
        return appComponent.fetchMonthAcademicScheduleUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->PlanComponent
private func factory84293b45082cab95c524f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PlanDependency0acb045bed3f80b42d39Provider(appComponent: parent1(component) as! AppComponent)
}
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
private class InfoSettingDependencyda5872b9bdd84990e780Provider: InfoSettingDependency {
    var signupUseCase: any SignupUseCase {
        return appComponent.signupUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->InfoSettingComponent
private func factory15af88ecfb834319b78cf47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return InfoSettingDependencyda5872b9bdd84990e780Provider(appComponent: parent1(component) as! AppComponent)
}
private class PasswordDependencyfd7427318599b626f4acProvider: PasswordDependency {


    init() {

    }
}
/// ^->AppComponent->PasswordComponent
private func factory9f8860811946a346ca2ae3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PasswordDependencyfd7427318599b626f4acProvider()
}
private class VerifyEmailDependencyfed6858d0bf434c6ec56Provider: VerifyEmailDependency {
    var emailSendUseCase: any EmailSendUseCase {
        return appComponent.emailSendUseCase
    }
    var codeCheckUseCase: any CodeCheckUseCase {
        return appComponent.codeCheckUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->VerifyEmailComponent
private func factoryeabc669822dd3244ed10f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return VerifyEmailDependencyfed6858d0bf434c6ec56Provider(appComponent: parent1(component) as! AppComponent)
}
private class SecretKeyDependencyb3e8d2bd4c35431acda1Provider: SecretKeyDependency {
    var secretKeyUseCase: any SecretKeyUseCase {
        return appComponent.secretKeyUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->SecretKeyComponent
private func factorycc7ea4e12027ae637f9ff47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SecretKeyDependencyb3e8d2bd4c35431acda1Provider(appComponent: parent1(component) as! AppComponent)
}
private class AllTabDependencyacdab75b3325eec9d649Provider: AllTabDependency {
    var getMyNameUseCase: any GetMyNameUseCaseProtocol {
        return appComponent.getMyNameUseCase
    }
    var authRepository: any AuthRepository {
        return appComponent.authRepository
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->AllTabComponent
private func factoryfffd4c52463116b1a1a9f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return AllTabDependencyacdab75b3325eec9d649Provider(appComponent: parent1(component) as! AppComponent)
}
private class SigninDependencyde06a9d0b22764487733Provider: SigninDependency {
    var signinUseCase: any SigninUseCase {
        return appComponent.signinUseCase
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
    var getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol {
        return appComponent.getSelfStudyDirectorUseCase
    }
    var getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol {
        return appComponent.getAdminSelfStudyInfoUseCase
    }
    var allTabFactory: any AllTabFactory {
        return appComponent.allTabFactory
    }
    var planFactory: any PlanFactory {
        return appComponent.planFactory
    }
    var acceptFactory: any AcceptFactory {
        return appComponent.acceptFactory
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->HomeComponent
private func factory67229cdf0f755562b2b1f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return HomeDependency443c4e1871277bd8432aProvider(appComponent: parent1(component) as! AppComponent)
}
private class AcceptDependency380d0282470c8b91ca89Provider: AcceptDependency {
    var getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol {
        return appComponent.getAllApplicationsUseCase
    }
    var getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol {
        return appComponent.getClassroomMovesUseCase
    }
    var updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol {
        return appComponent.updateApplicationStatusUseCase
    }
    var updateClassroomMoveStatusUseCase: any UpdateClassroomMoveStatusUseCaseProtocol {
        return appComponent.updateClassroomMoveStatusUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->AcceptComponent
private func factorye0727acbbfbe9e00fe23f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return AcceptDependency380d0282470c8b91ca89Provider(appComponent: parent1(component) as! AppComponent)
}

#else
extension PlanComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\PlanDependency.fetchAcademicScheduleUseCase] = "fetchAcademicScheduleUseCase-any FetchAcademicScheduleUseCaseProtocol"
        keyPathToName[\PlanDependency.fetchMonthAcademicScheduleUseCase] = "fetchMonthAcademicScheduleUseCase-any FetchMonthAcademicScheduleUseCaseProtocol"
    }
}
extension AppComponent: NeedleFoundation.Registration {
    public func registerItems() {

        localTable["keychain-any Keychain"] = { [unowned self] in self.keychain as Any }
        localTable["getSelfStudyDirectorUseCase-any GetSelfStudyDirectorUseCaseProtocol"] = { [unowned self] in self.getSelfStudyDirectorUseCase as Any }
        localTable["getAdminSelfStudyInfoUseCase-any GetAdminSelfStudyInfoUseCaseProtocol"] = { [unowned self] in self.getAdminSelfStudyInfoUseCase as Any }
        localTable["getAllApplicationsUseCase-any GetAllApplicationsUseCaseProtocol"] = { [unowned self] in self.getAllApplicationsUseCase as Any }
        localTable["getClassroomMovesUseCase-any GetClassroomMovesUseCaseProtocol"] = { [unowned self] in self.getClassroomMovesUseCase as Any }
        localTable["updateApplicationStatusUseCase-any UpdateApplicationStatusUseCaseProtocol"] = { [unowned self] in self.updateApplicationStatusUseCase as Any }
        localTable["updateClassroomMoveStatusUseCase-any UpdateClassroomMoveStatusUseCaseProtocol"] = { [unowned self] in self.updateClassroomMoveStatusUseCase as Any }
        localTable["fetchAcademicScheduleUseCase-any FetchAcademicScheduleUseCaseProtocol"] = { [unowned self] in self.fetchAcademicScheduleUseCase as Any }
        localTable["fetchMonthAcademicScheduleUseCase-any FetchMonthAcademicScheduleUseCaseProtocol"] = { [unowned self] in self.fetchMonthAcademicScheduleUseCase as Any }
        localTable["planFactory-any PlanFactory"] = { [unowned self] in self.planFactory as Any }
        localTable["getMyNameUseCase-any GetMyNameUseCaseProtocol"] = { [unowned self] in self.getMyNameUseCase as Any }
        localTable["signinFactory-any SigninFactory"] = { [unowned self] in self.signinFactory as Any }
        localTable["secretKeyFactory-any SecretKeyFactory"] = { [unowned self] in self.secretKeyFactory as Any }
        localTable["verifyEmailFactory-any VerifyEmailFactory"] = { [unowned self] in self.verifyEmailFactory as Any }
        localTable["passwordFactory-any PasswordFactory"] = { [unowned self] in self.passwordFactory as Any }
        localTable["infoSettingFactory-any InfoSettingFactory"] = { [unowned self] in self.infoSettingFactory as Any }
        localTable["onboardingFactory-any OnboardingFactory"] = { [unowned self] in self.onboardingFactory as Any }
        localTable["homeFactory-any HomeFactory"] = { [unowned self] in self.homeFactory as Any }
        localTable["allTabFactory-any AllTabFactory"] = { [unowned self] in self.allTabFactory as Any }
        localTable["acceptFactory-any AcceptFactory"] = { [unowned self] in self.acceptFactory as Any }
        localTable["userDefault-any UserDefault"] = { [unowned self] in self.userDefault as Any }
        localTable["authProvider-MoyaProvider<AuthAPI>"] = { [unowned self] in self.authProvider as Any }
        localTable["localAuthDataSource-any LocalAuthDataSource"] = { [unowned self] in self.localAuthDataSource as Any }
        localTable["remoteAuthDataSource-any RemoteAuthDataSource"] = { [unowned self] in self.remoteAuthDataSource as Any }
        localTable["remoteMailDataSource-any RemoteMailDataSource"] = { [unowned self] in self.remoteMailDataSource as Any }
        localTable["authRepository-any AuthRepository"] = { [unowned self] in self.authRepository as Any }
        localTable["mailRepository-any MailRepository"] = { [unowned self] in self.mailRepository as Any }
        localTable["signinUseCase-any SigninUseCase"] = { [unowned self] in self.signinUseCase as Any }
        localTable["refreshTokenUseCase-any RefreshTokenUseCase"] = { [unowned self] in self.refreshTokenUseCase as Any }
        localTable["secretKeyUseCase-any SecretKeyUseCase"] = { [unowned self] in self.secretKeyUseCase as Any }
        localTable["emailSendUseCase-any EmailSendUseCase"] = { [unowned self] in self.emailSendUseCase as Any }
        localTable["codeCheckUseCase-any CodeCheckUseCase"] = { [unowned self] in self.codeCheckUseCase as Any }
        localTable["signupUseCase-any SignupUseCase"] = { [unowned self] in self.signupUseCase as Any }
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
extension InfoSettingComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\InfoSettingDependency.signupUseCase] = "signupUseCase-any SignupUseCase"
    }
}
extension PasswordComponent: NeedleFoundation.Registration {
    public func registerItems() {

    }
}
extension VerifyEmailComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\VerifyEmailDependency.emailSendUseCase] = "emailSendUseCase-any EmailSendUseCase"
        keyPathToName[\VerifyEmailDependency.codeCheckUseCase] = "codeCheckUseCase-any CodeCheckUseCase"
    }
}
extension SecretKeyComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\SecretKeyDependency.secretKeyUseCase] = "secretKeyUseCase-any SecretKeyUseCase"
    }
}
extension AllTabComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\AllTabDependency.getMyNameUseCase] = "getMyNameUseCase-any GetMyNameUseCaseProtocol"
        keyPathToName[\AllTabDependency.authRepository] = "authRepository-any AuthRepository"
    }
}
extension SigninComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\SigninDependency.signinUseCase] = "signinUseCase-any SigninUseCase"
    }
}
extension HomeComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\HomeDependency.getSelfStudyDirectorUseCase] = "getSelfStudyDirectorUseCase-any GetSelfStudyDirectorUseCaseProtocol"
        keyPathToName[\HomeDependency.getAdminSelfStudyInfoUseCase] = "getAdminSelfStudyInfoUseCase-any GetAdminSelfStudyInfoUseCaseProtocol"
        keyPathToName[\HomeDependency.allTabFactory] = "allTabFactory-any AllTabFactory"
        keyPathToName[\HomeDependency.planFactory] = "planFactory-any PlanFactory"
        keyPathToName[\HomeDependency.acceptFactory] = "acceptFactory-any AcceptFactory"
    }
}
extension AcceptComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\AcceptDependency.getAllApplicationsUseCase] = "getAllApplicationsUseCase-any GetAllApplicationsUseCaseProtocol"
        keyPathToName[\AcceptDependency.getClassroomMovesUseCase] = "getClassroomMovesUseCase-any GetClassroomMovesUseCaseProtocol"
        keyPathToName[\AcceptDependency.updateApplicationStatusUseCase] = "updateApplicationStatusUseCase-any UpdateApplicationStatusUseCaseProtocol"
        keyPathToName[\AcceptDependency.updateClassroomMoveStatusUseCase] = "updateClassroomMoveStatusUseCase-any UpdateClassroomMoveStatusUseCaseProtocol"
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
    registerProviderFactory("^->AppComponent->PlanComponent", factory84293b45082cab95c524f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->RootComponent", factory264bfc4d4cb6b0629b40f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->OnboardingComponent", factory88dc13cc29c5719e2b01e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->InfoSettingComponent", factory15af88ecfb834319b78cf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->PasswordComponent", factory9f8860811946a346ca2ae3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->VerifyEmailComponent", factoryeabc669822dd3244ed10f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SecretKeyComponent", factorycc7ea4e12027ae637f9ff47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->AllTabComponent", factoryfffd4c52463116b1a1a9f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SigninComponent", factory2882a056d84a613debccf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->HomeComponent", factory67229cdf0f755562b2b1f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->AcceptComponent", factorye0727acbbfbe9e00fe23f47b58f8f304c97af4d5)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
