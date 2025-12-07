

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
import BugReportDomain
import BugReportDomainInterface
import BugReportFeature
import BugReportFeatureInterface
import ChangePasswordDomain
import ChangePasswordDomainInterface
import ChangePasswordFeature
import ChangePasswordFeatureInterface
import CheckSelfStudyTeacherDomain
import CheckSelfStudyTeacherDomainInterface
import CheckSelfStudyTeacherFeature
import CheckSelfStudyTeacherFeatureInterface
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
import OutListDomain
import OutListDomainInterface
import OutListFeature
import OutListFeatureInterface
import PlanDomain
import PlanDomainInterface
import PlanFeature
import PlanFeatureInterface
import SchoolMealDomain
import SchoolMealDomainInterface
import SchoolMealFeature
import SchoolMealFeatureInterface
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
private class SchoolMealDependencya734efcf6966c6d8c144Provider: SchoolMealDependency {
    var fetchSchoolMealUseCase: any FetchSchoolMealUseCaseProtocol {
        return appComponent.fetchSchoolMealUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->SchoolMealComponent
private func factorya99b85c0783e43e9302df47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SchoolMealDependencya734efcf6966c6d8c144Provider(appComponent: parent1(component) as! AppComponent)
}
private class OnboardingDependencyf77d0055983a00cf8835Provider: OnboardingDependency {


    init() {

    }
}
/// ^->AppComponent->OnboardingComponent
private func factory88dc13cc29c5719e2b01e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return OnboardingDependencyf77d0055983a00cf8835Provider()
}
private class CheckSelfStudyTeacherDependency18aa2dd6d35fe3494400Provider: CheckSelfStudyTeacherDependency {
    var fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol {
        return appComponent.fetchSelfStudyTeacherUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->CheckSelfStudyTeacherComponent
private func factory8da635de41c15b5c5bd3f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return CheckSelfStudyTeacherDependency18aa2dd6d35fe3494400Provider(appComponent: parent1(component) as! AppComponent)
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
private class BugReportDependencyeea5818852f336c35729Provider: BugReportDependency {
    var uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol {
        return appComponent.uploadBugImagesUseCase
    }
    var submitBugReportUseCase: any SubmitBugReportUseCaseProtocol {
        return appComponent.submitBugReportUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->BugReportComponent
private func factoryafa28e93c96a785ed32af47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return BugReportDependencyeea5818852f336c35729Provider(appComponent: parent1(component) as! AppComponent)
}
private class AllTabDependencyacdab75b3325eec9d649Provider: AllTabDependency {
    var getMyNameUseCase: any GetMyNameUseCaseProtocol {
        return appComponent.getMyNameUseCase
    }
    var authRepository: any AuthRepository {
        return appComponent.authRepository
    }
    var fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol {
        return appComponent.fetchSelfStudyTeacherUseCase
    }
    var uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol {
        return appComponent.uploadBugImagesUseCase
    }
    var submitBugReportUseCase: any SubmitBugReportUseCaseProtocol {
        return appComponent.submitBugReportUseCase
    }
    var emailSendUseCase: any EmailSendUseCase {
        return appComponent.emailSendUseCase
    }
    var codeCheckUseCase: any CodeCheckUseCase {
        return appComponent.codeCheckUseCase
    }
    var passwordChangeUseCase: any PasswordChangeUseCase {
        return appComponent.passwordChangeUseCase
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
private class OutListDependencyac9793ee3f8a81768455Provider: OutListDependency {
    var getOutListUseCase: any GetOutListUseCase {
        return appComponent.getOutListUseCase
    }
    var returnStudentsUseCase: any ReturnStudentsUseCase {
        return appComponent.returnStudentsUseCase
    }
    var getEarlyReturnUseCase: any GetEarlyReturnUseCase {
        return appComponent.getEarlyReturnUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->OutListComponent
private func factoryb7dc05e5bded91c750e2f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return OutListDependencyac9793ee3f8a81768455Provider(appComponent: parent1(component) as! AppComponent)
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
    var schoolMealFactory: any SchoolMealFactory {
        return appComponent.schoolMealFactory
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
private class ChangePasswordDependency04ab7ced24136c4fb27eProvider: ChangePasswordDependency {
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
/// ^->AppComponent->ChangePasswordComponent
private func factoryab7c4d87dab53e0a51b9f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ChangePasswordDependency04ab7ced24136c4fb27eProvider(appComponent: parent1(component) as! AppComponent)
}
private class NewPasswordDependency3320cbf6e40b8cd8a8eaProvider: NewPasswordDependency {
    var passwordChangeUseCase: any PasswordChangeUseCase {
        return appComponent.passwordChangeUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->NewPasswordComponent
private func factory52985a6d5ec65d75bd97f47b58f8f304c97af4d5(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NewPasswordDependency3320cbf6e40b8cd8a8eaProvider(appComponent: parent1(component) as! AppComponent)
}
private class AcceptDependency380d0282470c8b91ca89Provider: AcceptDependency {
    var getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol {
        return appComponent.getAllApplicationsUseCase
    }
    var getApplicationsByFloorUseCase: any GetApplicationsByFloorUseCaseProtocol {
        return appComponent.getApplicationsByFloorUseCase
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
        localTable["getApplicationsByFloorUseCase-any GetApplicationsByFloorUseCaseProtocol"] = { [unowned self] in self.getApplicationsByFloorUseCase as Any }
        localTable["getClassroomMovesUseCase-any GetClassroomMovesUseCaseProtocol"] = { [unowned self] in self.getClassroomMovesUseCase as Any }
        localTable["updateApplicationStatusUseCase-any UpdateApplicationStatusUseCaseProtocol"] = { [unowned self] in self.updateApplicationStatusUseCase as Any }
        localTable["updateClassroomMoveStatusUseCase-any UpdateClassroomMoveStatusUseCaseProtocol"] = { [unowned self] in self.updateClassroomMoveStatusUseCase as Any }
        localTable["bugReportDataSource-BugReportDataSource"] = { [unowned self] in self.bugReportDataSource as Any }
        localTable["bugReportRepository-BugReportRepository"] = { [unowned self] in self.bugReportRepository as Any }
        localTable["uploadBugImagesUseCase-any UploadBugImagesUseCaseProtocol"] = { [unowned self] in self.uploadBugImagesUseCase as Any }
        localTable["submitBugReportUseCase-any SubmitBugReportUseCaseProtocol"] = { [unowned self] in self.submitBugReportUseCase as Any }
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
        localTable["checkSelfStudyTeacherFactory-any CheckSelfStudyTeacherFactory"] = { [unowned self] in self.checkSelfStudyTeacherFactory as Any }
        localTable["bugReportFactory-any BugReportFactory"] = { [unowned self] in self.bugReportFactory as Any }
        localTable["changePasswordFactory-any ChangePasswordFactory"] = { [unowned self] in self.changePasswordFactory as Any }
        localTable["newPasswordFactory-any NewPasswordFactory"] = { [unowned self] in self.newPasswordFactory as Any }
        localTable["outListFactory-any OutListFactory"] = { [unowned self] in self.outListFactory as Any }
        localTable["fetchSelfStudyTeacherUseCase-any FetchSelfStudyTeacherUseCaseProtocol"] = { [unowned self] in self.fetchSelfStudyTeacherUseCase as Any }
        localTable["changePasswordProvider-MoyaProvider<ChangePasswordAPI>"] = { [unowned self] in self.changePasswordProvider as Any }
        localTable["remoteChangePasswordDataSource-any RemoteChangePasswordDataSource"] = { [unowned self] in self.remoteChangePasswordDataSource as Any }
        localTable["changePasswordRepository-any ChangePasswordRepository"] = { [unowned self] in self.changePasswordRepository as Any }
        localTable["passwordChangeUseCase-any PasswordChangeUseCase"] = { [unowned self] in self.passwordChangeUseCase as Any }
        localTable["getOutListUseCase-any GetOutListUseCase"] = { [unowned self] in self.getOutListUseCase as Any }
        localTable["returnStudentsUseCase-any ReturnStudentsUseCase"] = { [unowned self] in self.returnStudentsUseCase as Any }
        localTable["getEarlyReturnUseCase-any GetEarlyReturnUseCase"] = { [unowned self] in self.getEarlyReturnUseCase as Any }
        localTable["fetchSchoolMealUseCase-any FetchSchoolMealUseCaseProtocol"] = { [unowned self] in self.fetchSchoolMealUseCase as Any }
        localTable["schoolMealFactory-any SchoolMealFactory"] = { [unowned self] in self.schoolMealFactory as Any }
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
extension SchoolMealComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\SchoolMealDependency.fetchSchoolMealUseCase] = "fetchSchoolMealUseCase-any FetchSchoolMealUseCaseProtocol"
    }
}
extension OnboardingComponent: NeedleFoundation.Registration {
    public func registerItems() {

    }
}
extension CheckSelfStudyTeacherComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\CheckSelfStudyTeacherDependency.fetchSelfStudyTeacherUseCase] = "fetchSelfStudyTeacherUseCase-any FetchSelfStudyTeacherUseCaseProtocol"
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
extension BugReportComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\BugReportDependency.uploadBugImagesUseCase] = "uploadBugImagesUseCase-any UploadBugImagesUseCaseProtocol"
        keyPathToName[\BugReportDependency.submitBugReportUseCase] = "submitBugReportUseCase-any SubmitBugReportUseCaseProtocol"
    }
}
extension AllTabComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\AllTabDependency.getMyNameUseCase] = "getMyNameUseCase-any GetMyNameUseCaseProtocol"
        keyPathToName[\AllTabDependency.authRepository] = "authRepository-any AuthRepository"
        keyPathToName[\AllTabDependency.fetchSelfStudyTeacherUseCase] = "fetchSelfStudyTeacherUseCase-any FetchSelfStudyTeacherUseCaseProtocol"
        keyPathToName[\AllTabDependency.uploadBugImagesUseCase] = "uploadBugImagesUseCase-any UploadBugImagesUseCaseProtocol"
        keyPathToName[\AllTabDependency.submitBugReportUseCase] = "submitBugReportUseCase-any SubmitBugReportUseCaseProtocol"
        keyPathToName[\AllTabDependency.emailSendUseCase] = "emailSendUseCase-any EmailSendUseCase"
        keyPathToName[\AllTabDependency.codeCheckUseCase] = "codeCheckUseCase-any CodeCheckUseCase"
        keyPathToName[\AllTabDependency.passwordChangeUseCase] = "passwordChangeUseCase-any PasswordChangeUseCase"
    }
}
extension OutListComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\OutListDependency.getOutListUseCase] = "getOutListUseCase-any GetOutListUseCase"
        keyPathToName[\OutListDependency.returnStudentsUseCase] = "returnStudentsUseCase-any ReturnStudentsUseCase"
        keyPathToName[\OutListDependency.getEarlyReturnUseCase] = "getEarlyReturnUseCase-any GetEarlyReturnUseCase"
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
        keyPathToName[\HomeDependency.schoolMealFactory] = "schoolMealFactory-any SchoolMealFactory"
        keyPathToName[\HomeDependency.acceptFactory] = "acceptFactory-any AcceptFactory"
    }
}
extension ChangePasswordComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\ChangePasswordDependency.emailSendUseCase] = "emailSendUseCase-any EmailSendUseCase"
        keyPathToName[\ChangePasswordDependency.codeCheckUseCase] = "codeCheckUseCase-any CodeCheckUseCase"
    }
}
extension NewPasswordComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\NewPasswordDependency.passwordChangeUseCase] = "passwordChangeUseCase-any PasswordChangeUseCase"
    }
}
extension AcceptComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\AcceptDependency.getAllApplicationsUseCase] = "getAllApplicationsUseCase-any GetAllApplicationsUseCaseProtocol"
        keyPathToName[\AcceptDependency.getApplicationsByFloorUseCase] = "getApplicationsByFloorUseCase-any GetApplicationsByFloorUseCaseProtocol"
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
    registerProviderFactory("^->AppComponent->SchoolMealComponent", factorya99b85c0783e43e9302df47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->OnboardingComponent", factory88dc13cc29c5719e2b01e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->CheckSelfStudyTeacherComponent", factory8da635de41c15b5c5bd3f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->InfoSettingComponent", factory15af88ecfb834319b78cf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->PasswordComponent", factory9f8860811946a346ca2ae3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->VerifyEmailComponent", factoryeabc669822dd3244ed10f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SecretKeyComponent", factorycc7ea4e12027ae637f9ff47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->BugReportComponent", factoryafa28e93c96a785ed32af47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->AllTabComponent", factoryfffd4c52463116b1a1a9f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->OutListComponent", factoryb7dc05e5bded91c750e2f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SigninComponent", factory2882a056d84a613debccf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->HomeComponent", factory67229cdf0f755562b2b1f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->ChangePasswordComponent", factoryab7c4d87dab53e0a51b9f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->NewPasswordComponent", factory52985a6d5ec65d75bd97f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->AcceptComponent", factorye0727acbbfbe9e00fe23f47b58f8f304c97af4d5)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
