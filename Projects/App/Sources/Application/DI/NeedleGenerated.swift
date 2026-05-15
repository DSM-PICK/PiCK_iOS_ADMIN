

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
import ClassroomMoveListDomain
import ClassroomMoveListDomainInterface
import ClassroomMoveListFeature
import ClassroomMoveListFeatureInterface
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
import OutingHistoryDomain
import OutingHistoryDomainInterface
import OutingHistoryFeature
import OutingHistoryFeatureInterface
import PlanDomain
import PlanDomainInterface
import PlanFeature
import PlanFeatureInterface
import SchoolMealDomain
import SchoolMealDomainInterface
import SchoolMealFeature
import SchoolMealFeatureInterface
import SelfStudyCheckDomain
import SelfStudyCheckDomainInterface
import SelfStudyCheckFeature
import SelfStudyCheckFeatureInterface
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

private func parent2(_ component: NeedleFoundation.Scope) -> NeedleFoundation.Scope {
    return component.parent.parent
}

// MARK: - Providers

#if !NEEDLE_DYNAMIC

private class HomeDependency443c4e1871277bd8432aProvider: HomeDependency {
    var getSelfStudyDirectorUseCase: any GetSelfStudyDirectorUseCaseProtocol {
        return appComponent.getSelfStudyDirectorUseCase
    }
    var getAdminSelfStudyInfoUseCase: any GetAdminSelfStudyInfoUseCaseProtocol {
        return appComponent.getAdminSelfStudyInfoUseCase
    }
    var getSelfStudyAndClassroomUseCase: any GetSelfStudyAndClassroomUseCase {
        return appComponent.getSelfStudyAndClassroomUseCase
    }
    var getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol {
        return appComponent.getAllApplicationsUseCase
    }
    var updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol {
        return appComponent.updateApplicationStatusUseCase
    }
    var getEarlyReturnByGradeUseCase: any GetEarlyReturnByGradeUseCaseProtocol {
        return appComponent.getEarlyReturnByGradeUseCase
    }
    var updateEarlyReturnStatusUseCase: any UpdateEarlyReturnStatusUseCaseProtocol {
        return appComponent.updateEarlyReturnStatusUseCase
    }
    var getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase {
        return appComponent.getClassroomMoveByFloorUseCase
    }
    var getOutListUseCase: any GetOutListUseCase {
        return appComponent.getOutListUseCase
    }
    var getEarlyReturnUseCase: any GetEarlyReturnUseCase {
        return appComponent.getEarlyReturnUseCase
    }
    var allTabFactory: any AllTabFactory {
        return appComponent.allTabFactory
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
private class PlanDependency598ef68688890897ecfaProvider: PlanDependency {
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
/// ^->AppComponent->HomeComponent->PlanComponent
private func factory3816f306e57691f6cbc3b7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return PlanDependency598ef68688890897ecfaProvider(appComponent: parent2(component) as! AppComponent)
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
private class SchoolMealDependency80df08e400a5b36d3bc3Provider: SchoolMealDependency {
    var fetchSchoolMealUseCase: any FetchSchoolMealUseCaseProtocol {
        return appComponent.fetchSchoolMealUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->HomeComponent->SchoolMealComponent
private func factory354b0e0b58c0b30e89fcb7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SchoolMealDependency80df08e400a5b36d3bc3Provider(appComponent: parent2(component) as! AppComponent)
}
private class OnboardingDependencyf77d0055983a00cf8835Provider: OnboardingDependency {


    init() {

    }
}
/// ^->AppComponent->OnboardingComponent
private func factory88dc13cc29c5719e2b01e3b0c44298fc1c149afb(_ component: NeedleFoundation.Scope) -> AnyObject {
    return OnboardingDependencyf77d0055983a00cf8835Provider()
}
private class CheckSelfStudyTeacherDependency9170675b14a508f4e631Provider: CheckSelfStudyTeacherDependency {
    var fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol {
        return appComponent.fetchSelfStudyTeacherUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->AllTabComponent->CheckSelfStudyTeacherComponent
private func factoryc77fbcbfa8694fb5c9a8b7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return CheckSelfStudyTeacherDependency9170675b14a508f4e631Provider(appComponent: parent2(component) as! AppComponent)
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
private class BugReportDependency37ddb4f6022e0960e049Provider: BugReportDependency {
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
/// ^->AppComponent->AllTabComponent->BugReportComponent
private func factoryd6fef93a5810f389e51eb7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return BugReportDependency37ddb4f6022e0960e049Provider(appComponent: parent2(component) as! AppComponent)
}
private class ClassroomMoveListDependency93ef4ef1fcc22c78cba4Provider: ClassroomMoveListDependency {
    var getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase {
        return appComponent.getClassroomMoveByFloorUseCase
    }
    var getClassroomMoveByClassroomUseCase: any GetClassroomMoveByClassroomUseCase {
        return appComponent.getClassroomMoveByClassroomUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->AllTabComponent->ClassroomMoveListComponent
private func factory95045edcceaacbea5719b7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ClassroomMoveListDependency93ef4ef1fcc22c78cba4Provider(appComponent: parent2(component) as! AppComponent)
}
private class OutListDependency29d39594a3cb1cf9f082Provider: OutListDependency {
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
/// ^->AppComponent->AllTabComponent->OutListComponent
private func factoryd807be069474159d19eab7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return OutListDependency29d39594a3cb1cf9f082Provider(appComponent: parent2(component) as! AppComponent)
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
private class ChangePasswordDependency5eba0402bbcbcd261d42Provider: ChangePasswordDependency {
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
/// ^->AppComponent->AllTabComponent->ChangePasswordComponent
private func factory467160258c9ac01b7c5bb7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return ChangePasswordDependency5eba0402bbcbcd261d42Provider(appComponent: parent2(component) as! AppComponent)
}
private class NewPasswordDependencye479985f5458a2140313Provider: NewPasswordDependency {
    var passwordChangeUseCase: any PasswordChangeUseCase {
        return appComponent.passwordChangeUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->AllTabComponent->NewPasswordComponent
private func factory72c947c482b2178b6ac8b7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return NewPasswordDependencye479985f5458a2140313Provider(appComponent: parent2(component) as! AppComponent)
}
private class OutingHistoryDependency1ac9b452541cc7666f26Provider: OutingHistoryDependency {
    var getOutingHistoryUseCase: any GetOutingHistoryUseCase {
        return appComponent.getOutingHistoryUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->AllTabComponent->OutingHistoryComponent
private func factory9b4dc0b099c64971113cb7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return OutingHistoryDependency1ac9b452541cc7666f26Provider(appComponent: parent2(component) as! AppComponent)
}
private class SelfStudyCheckDependency4136fbacab02a58f4193Provider: SelfStudyCheckDependency {
    var getStudentAttendanceUseCase: any GetStudentAttendanceUseCase {
        return appComponent.getStudentAttendanceUseCase
    }
    var saveAttendanceUseCase: any SaveAttendanceUseCase {
        return appComponent.saveAttendanceUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->AllTabComponent->SelfStudyCheckComponent
private func factory16eaf6e424be7fbccc0ab7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return SelfStudyCheckDependency4136fbacab02a58f4193Provider(appComponent: parent2(component) as! AppComponent)
}
private class AcceptDependency65aa8b2a4111fcb6c343Provider: AcceptDependency {
    var getAllApplicationsUseCase: any GetAllApplicationsUseCaseProtocol {
        return appComponent.getAllApplicationsUseCase
    }
    var getApplicationsByFloorUseCase: any GetApplicationsByFloorUseCaseProtocol {
        return appComponent.getApplicationsByFloorUseCase
    }
    var getClassroomMovesUseCase: any GetClassroomMovesUseCaseProtocol {
        return appComponent.getClassroomMovesUseCase
    }
    var getEarlyReturnByGradeUseCase: any GetEarlyReturnByGradeUseCaseProtocol {
        return appComponent.getEarlyReturnByGradeUseCase
    }
    var updateApplicationStatusUseCase: any UpdateApplicationStatusUseCaseProtocol {
        return appComponent.updateApplicationStatusUseCase
    }
    var updateClassroomMoveStatusUseCase: any UpdateClassroomMoveStatusUseCaseProtocol {
        return appComponent.updateClassroomMoveStatusUseCase
    }
    var updateEarlyReturnStatusUseCase: any UpdateEarlyReturnStatusUseCaseProtocol {
        return appComponent.updateEarlyReturnStatusUseCase
    }
    private let appComponent: AppComponent
    init(appComponent: AppComponent) {
        self.appComponent = appComponent
    }
}
/// ^->AppComponent->HomeComponent->AcceptComponent
private func factory6619f4a5130bf1e2dcacb7304b634b3e62c64b3c(_ component: NeedleFoundation.Scope) -> AnyObject {
    return AcceptDependency65aa8b2a4111fcb6c343Provider(appComponent: parent2(component) as! AppComponent)
}

#else
extension HomeComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\HomeDependency.getSelfStudyDirectorUseCase] = "getSelfStudyDirectorUseCase-any GetSelfStudyDirectorUseCaseProtocol"
        keyPathToName[\HomeDependency.getAdminSelfStudyInfoUseCase] = "getAdminSelfStudyInfoUseCase-any GetAdminSelfStudyInfoUseCaseProtocol"
        keyPathToName[\HomeDependency.getSelfStudyAndClassroomUseCase] = "getSelfStudyAndClassroomUseCase-any GetSelfStudyAndClassroomUseCase"
        keyPathToName[\HomeDependency.getAllApplicationsUseCase] = "getAllApplicationsUseCase-any GetAllApplicationsUseCaseProtocol"
        keyPathToName[\HomeDependency.updateApplicationStatusUseCase] = "updateApplicationStatusUseCase-any UpdateApplicationStatusUseCaseProtocol"
        keyPathToName[\HomeDependency.getEarlyReturnByGradeUseCase] = "getEarlyReturnByGradeUseCase-any GetEarlyReturnByGradeUseCaseProtocol"
        keyPathToName[\HomeDependency.updateEarlyReturnStatusUseCase] = "updateEarlyReturnStatusUseCase-any UpdateEarlyReturnStatusUseCaseProtocol"
        keyPathToName[\HomeDependency.getClassroomMoveByFloorUseCase] = "getClassroomMoveByFloorUseCase-any GetClassroomMoveByFloorUseCase"
        keyPathToName[\HomeDependency.getOutListUseCase] = "getOutListUseCase-any GetOutListUseCase"
        keyPathToName[\HomeDependency.getEarlyReturnUseCase] = "getEarlyReturnUseCase-any GetEarlyReturnUseCase"
        keyPathToName[\HomeDependency.allTabFactory] = "allTabFactory-any AllTabFactory"

    }
}
extension PlanComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\PlanDependency.fetchAcademicScheduleUseCase] = "fetchAcademicScheduleUseCase-any FetchAcademicScheduleUseCaseProtocol"
        keyPathToName[\PlanDependency.fetchMonthAcademicScheduleUseCase] = "fetchMonthAcademicScheduleUseCase-any FetchMonthAcademicScheduleUseCaseProtocol"
    }
}
extension AllTabComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\AllTabDependency.getMyNameUseCase] = "getMyNameUseCase-any GetMyNameUseCaseProtocol"
        keyPathToName[\AllTabDependency.authRepository] = "authRepository-any AuthRepository"

    }
}
extension AppComponent: NeedleFoundation.Registration {
    public func registerItems() {

        localTable["keychain-any Keychain"] = { [unowned self] in self.keychain as Any }
        localTable["getSelfStudyDirectorUseCase-any GetSelfStudyDirectorUseCaseProtocol"] = { [unowned self] in self.getSelfStudyDirectorUseCase as Any }
        localTable["getAdminSelfStudyInfoUseCase-any GetAdminSelfStudyInfoUseCaseProtocol"] = { [unowned self] in self.getAdminSelfStudyInfoUseCase as Any }
        localTable["getSelfStudyAndClassroomUseCase-any GetSelfStudyAndClassroomUseCase"] = { [unowned self] in self.getSelfStudyAndClassroomUseCase as Any }
        localTable["getOutingHistoryUseCase-any GetOutingHistoryUseCase"] = { [unowned self] in self.getOutingHistoryUseCase as Any }
        localTable["getAllApplicationsUseCase-any GetAllApplicationsUseCaseProtocol"] = { [unowned self] in self.getAllApplicationsUseCase as Any }
        localTable["getApplicationsByFloorUseCase-any GetApplicationsByFloorUseCaseProtocol"] = { [unowned self] in self.getApplicationsByFloorUseCase as Any }
        localTable["getClassroomMovesUseCase-any GetClassroomMovesUseCaseProtocol"] = { [unowned self] in self.getClassroomMovesUseCase as Any }
        localTable["getEarlyReturnByGradeUseCase-any GetEarlyReturnByGradeUseCaseProtocol"] = { [unowned self] in self.getEarlyReturnByGradeUseCase as Any }
        localTable["updateApplicationStatusUseCase-any UpdateApplicationStatusUseCaseProtocol"] = { [unowned self] in self.updateApplicationStatusUseCase as Any }
        localTable["updateClassroomMoveStatusUseCase-any UpdateClassroomMoveStatusUseCaseProtocol"] = { [unowned self] in self.updateClassroomMoveStatusUseCase as Any }
        localTable["updateEarlyReturnStatusUseCase-any UpdateEarlyReturnStatusUseCaseProtocol"] = { [unowned self] in self.updateEarlyReturnStatusUseCase as Any }
        localTable["bugReportDataSource-BugReportDataSource"] = { [unowned self] in self.bugReportDataSource as Any }
        localTable["bugReportRepository-BugReportRepository"] = { [unowned self] in self.bugReportRepository as Any }
        localTable["uploadBugImagesUseCase-any UploadBugImagesUseCaseProtocol"] = { [unowned self] in self.uploadBugImagesUseCase as Any }
        localTable["submitBugReportUseCase-any SubmitBugReportUseCaseProtocol"] = { [unowned self] in self.submitBugReportUseCase as Any }
        localTable["getClassroomMoveByFloorUseCase-any GetClassroomMoveByFloorUseCase"] = { [unowned self] in self.getClassroomMoveByFloorUseCase as Any }
        localTable["getClassroomMoveByClassroomUseCase-any GetClassroomMoveByClassroomUseCase"] = { [unowned self] in self.getClassroomMoveByClassroomUseCase as Any }
        localTable["fetchAcademicScheduleUseCase-any FetchAcademicScheduleUseCaseProtocol"] = { [unowned self] in self.fetchAcademicScheduleUseCase as Any }
        localTable["fetchMonthAcademicScheduleUseCase-any FetchMonthAcademicScheduleUseCaseProtocol"] = { [unowned self] in self.fetchMonthAcademicScheduleUseCase as Any }
        localTable["getMyNameUseCase-any GetMyNameUseCaseProtocol"] = { [unowned self] in self.getMyNameUseCase as Any }
        localTable["signinFactory-any SigninFactory"] = { [unowned self] in self.signinFactory as Any }
        localTable["secretKeyFactory-any SecretKeyFactory"] = { [unowned self] in self.secretKeyFactory as Any }
        localTable["verifyEmailFactory-any VerifyEmailFactory"] = { [unowned self] in self.verifyEmailFactory as Any }
        localTable["passwordFactory-any PasswordFactory"] = { [unowned self] in self.passwordFactory as Any }
        localTable["infoSettingFactory-any InfoSettingFactory"] = { [unowned self] in self.infoSettingFactory as Any }
        localTable["onboardingFactory-any OnboardingFactory"] = { [unowned self] in self.onboardingFactory as Any }
        localTable["homeFactory-any HomeFactory"] = { [unowned self] in self.homeFactory as Any }
        localTable["allTabFactory-any AllTabFactory"] = { [unowned self] in self.allTabFactory as Any }
        localTable["fetchSelfStudyTeacherUseCase-any FetchSelfStudyTeacherUseCaseProtocol"] = { [unowned self] in self.fetchSelfStudyTeacherUseCase as Any }
        localTable["changePasswordProvider-MoyaProvider<ChangePasswordAPI>"] = { [unowned self] in self.changePasswordProvider as Any }
        localTable["remoteChangePasswordDataSource-any RemoteChangePasswordDataSource"] = { [unowned self] in self.remoteChangePasswordDataSource as Any }
        localTable["changePasswordRepository-any ChangePasswordRepository"] = { [unowned self] in self.changePasswordRepository as Any }
        localTable["passwordChangeUseCase-any PasswordChangeUseCase"] = { [unowned self] in self.passwordChangeUseCase as Any }
        localTable["getOutListUseCase-any GetOutListUseCase"] = { [unowned self] in self.getOutListUseCase as Any }
        localTable["returnStudentsUseCase-any ReturnStudentsUseCase"] = { [unowned self] in self.returnStudentsUseCase as Any }
        localTable["getEarlyReturnUseCase-any GetEarlyReturnUseCase"] = { [unowned self] in self.getEarlyReturnUseCase as Any }
        localTable["getStudentAttendanceUseCase-any GetStudentAttendanceUseCase"] = { [unowned self] in self.getStudentAttendanceUseCase as Any }
        localTable["saveAttendanceUseCase-any SaveAttendanceUseCase"] = { [unowned self] in self.saveAttendanceUseCase as Any }
        localTable["fetchSchoolMealUseCase-any FetchSchoolMealUseCaseProtocol"] = { [unowned self] in self.fetchSchoolMealUseCase as Any }
        localTable["userDefault-any UserDefault"] = { [unowned self] in self.userDefault as Any }
        localTable["authProvider-MoyaProvider<AuthAPI>"] = { [unowned self] in self.authProvider as Any }
        localTable["localAuthDataSource-any LocalAuthDataSource"] = { [unowned self] in self.localAuthDataSource as Any }
        localTable["remoteAuthDataSource-any RemoteAuthDataSource"] = { [unowned self] in self.remoteAuthDataSource as Any }
        localTable["remoteMailDataSource-any RemoteMailDataSource"] = { [unowned self] in self.remoteMailDataSource as Any }
        localTable["authRepository-any AuthRepository"] = { [unowned self] in self.authRepository as Any }
        localTable["mailRepository-any MailRepository"] = { [unowned self] in self.mailRepository as Any }
        localTable["signinUseCase-any SigninUseCase"] = { [unowned self] in self.signinUseCase as Any }
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
extension ClassroomMoveListComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\ClassroomMoveListDependency.getClassroomMoveByFloorUseCase] = "getClassroomMoveByFloorUseCase-any GetClassroomMoveByFloorUseCase"
        keyPathToName[\ClassroomMoveListDependency.getClassroomMoveByClassroomUseCase] = "getClassroomMoveByClassroomUseCase-any GetClassroomMoveByClassroomUseCase"
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
extension OutingHistoryComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\OutingHistoryDependency.getOutingHistoryUseCase] = "getOutingHistoryUseCase-any GetOutingHistoryUseCase"
    }
}
extension SelfStudyCheckComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\SelfStudyCheckDependency.getStudentAttendanceUseCase] = "getStudentAttendanceUseCase-any GetStudentAttendanceUseCase"
        keyPathToName[\SelfStudyCheckDependency.saveAttendanceUseCase] = "saveAttendanceUseCase-any SaveAttendanceUseCase"
    }
}
extension AcceptComponent: NeedleFoundation.Registration {
    public func registerItems() {
        keyPathToName[\AcceptDependency.getAllApplicationsUseCase] = "getAllApplicationsUseCase-any GetAllApplicationsUseCaseProtocol"
        keyPathToName[\AcceptDependency.getApplicationsByFloorUseCase] = "getApplicationsByFloorUseCase-any GetApplicationsByFloorUseCaseProtocol"
        keyPathToName[\AcceptDependency.getClassroomMovesUseCase] = "getClassroomMovesUseCase-any GetClassroomMovesUseCaseProtocol"
        keyPathToName[\AcceptDependency.getEarlyReturnByGradeUseCase] = "getEarlyReturnByGradeUseCase-any GetEarlyReturnByGradeUseCaseProtocol"
        keyPathToName[\AcceptDependency.updateApplicationStatusUseCase] = "updateApplicationStatusUseCase-any UpdateApplicationStatusUseCaseProtocol"
        keyPathToName[\AcceptDependency.updateClassroomMoveStatusUseCase] = "updateClassroomMoveStatusUseCase-any UpdateClassroomMoveStatusUseCaseProtocol"
        keyPathToName[\AcceptDependency.updateEarlyReturnStatusUseCase] = "updateEarlyReturnStatusUseCase-any UpdateEarlyReturnStatusUseCaseProtocol"
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
    registerProviderFactory("^->AppComponent->HomeComponent", factory67229cdf0f755562b2b1f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->HomeComponent->PlanComponent", factory3816f306e57691f6cbc3b7304b634b3e62c64b3c)
    registerProviderFactory("^->AppComponent->AllTabComponent", factoryfffd4c52463116b1a1a9f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent", factoryEmptyDependencyProvider)
    registerProviderFactory("^->AppComponent->RootComponent", factory264bfc4d4cb6b0629b40f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->HomeComponent->SchoolMealComponent", factory354b0e0b58c0b30e89fcb7304b634b3e62c64b3c)
    registerProviderFactory("^->AppComponent->OnboardingComponent", factory88dc13cc29c5719e2b01e3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->AllTabComponent->CheckSelfStudyTeacherComponent", factoryc77fbcbfa8694fb5c9a8b7304b634b3e62c64b3c)
    registerProviderFactory("^->AppComponent->InfoSettingComponent", factory15af88ecfb834319b78cf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->PasswordComponent", factory9f8860811946a346ca2ae3b0c44298fc1c149afb)
    registerProviderFactory("^->AppComponent->VerifyEmailComponent", factoryeabc669822dd3244ed10f47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->SecretKeyComponent", factorycc7ea4e12027ae637f9ff47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->AllTabComponent->BugReportComponent", factoryd6fef93a5810f389e51eb7304b634b3e62c64b3c)
    registerProviderFactory("^->AppComponent->AllTabComponent->ClassroomMoveListComponent", factory95045edcceaacbea5719b7304b634b3e62c64b3c)
    registerProviderFactory("^->AppComponent->AllTabComponent->OutListComponent", factoryd807be069474159d19eab7304b634b3e62c64b3c)
    registerProviderFactory("^->AppComponent->SigninComponent", factory2882a056d84a613debccf47b58f8f304c97af4d5)
    registerProviderFactory("^->AppComponent->AllTabComponent->ChangePasswordComponent", factory467160258c9ac01b7c5bb7304b634b3e62c64b3c)
    registerProviderFactory("^->AppComponent->AllTabComponent->NewPasswordComponent", factory72c947c482b2178b6ac8b7304b634b3e62c64b3c)
    registerProviderFactory("^->AppComponent->AllTabComponent->OutingHistoryComponent", factory9b4dc0b099c64971113cb7304b634b3e62c64b3c)
    registerProviderFactory("^->AppComponent->AllTabComponent->SelfStudyCheckComponent", factory16eaf6e424be7fbccc0ab7304b634b3e62c64b3c)
    registerProviderFactory("^->AppComponent->HomeComponent->AcceptComponent", factory6619f4a5130bf1e2dcacb7304b634b3e62c64b3c)
}
#endif

public func registerProviderFactories() {
#if !NEEDLE_DYNAMIC
    register1()
#endif
}
