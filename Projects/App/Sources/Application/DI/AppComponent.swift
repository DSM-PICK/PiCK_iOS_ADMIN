import NeedleFoundation
import SwiftUI
import Core
import SigninFeature
import SigninFeatureInterface
import SignupFeature
import SignupFeatureInterface
import OnboardingFeature
import OnboardingFeatureInterface
import HomeFeature
import HomeFeatureInterface
import AllTabFeature
import AllTabFeatureInterface
import SchoolMealFeature
import SchoolMealFeatureInterface
import AcceptFeature
import AcceptFeatureInterface
import CheckSelfStudyTeacherFeature
import CheckSelfStudyTeacherFeatureInterface
import BugReportFeature
import BugReportFeatureInterface
import ChangePasswordFeature
import OutListFeature
import OutListFeatureInterface
import SelfStudyCheckFeature
import SelfStudyCheckFeatureInterface
import ClassroomMoveListFeature
import ClassroomMoveListFeatureInterface
import OutingHistoryFeature
import OutingHistoryFeatureInterface
import ResignFeature
import ResignFeatureInterface

public final class AppComponent: BootstrapComponent, HomeDependency, AllTabDependency, PlanDependency, SchoolMealDependency, AcceptDependency, CheckSelfStudyTeacherDependency, BugReportDependency, ChangePasswordDependency, NewPasswordDependency, ClassroomMoveListDependency, OutingHistoryDependency, SelfStudyCheckDependency, ResignDependency {

    private let _keychain: any Keychain

    init(keychain: any Keychain) {
        self._keychain = keychain
    }

    public func makeRootView() -> some View {
        rootComponent.makeView()
    }

    public var keychain: any Keychain {
        shared {
            _keychain
        }
    }

    var rootComponent: RootComponent {
        shared {
            RootComponent(parent: self)
        }
    }
}

// MARK: - Features
public extension AppComponent {
    var signinFactory: any SigninFactory {
        SigninComponent(parent: self)
    }
    var secretKeyFactory: any SecretKeyFactory {
        SecretKeyComponent(parent: self)
    }
    var verifyEmailFactory: any VerifyEmailFactory {
        VerifyEmailComponent(parent: self)
    }
    var passwordFactory: any PasswordFactory {
        PasswordComponent(parent: self)
    }
    var infoSettingFactory: any InfoSettingFactory {
        InfoSettingComponent(parent: self)
    }
    var onboardingFactory: any OnboardingFactory {
        OnboardingComponent(parent: self)
    }
    var homeFactory: any HomeFactory {
        HomeComponent(parent: self)
    }
    var allTabFactory: any AllTabFactory {
        AllTabComponent(parent: self)
    }
    var acceptFactory: any AcceptFactory {
        AcceptComponent(parent: self)
    }
    var checkSelfStudyTeacherFactory: any CheckSelfStudyTeacherFactory {
        CheckSelfStudyTeacherComponent(parent: self)
    }
    var bugReportFactory: any BugReportFactory {
        BugReportComponent(parent: self)
    }
    var changePasswordFactory: any ChangePasswordFactory {
        ChangePasswordComponent(parent: self)
    }
    var newPasswordFactory: any NewPasswordFactory {
        NewPasswordComponent(parent: self)
    }
    var outListFactory: any OutListFactory {
        OutListComponent(parent: self)
    }
    var selfStudyCheckFactory: any SelfStudyCheckFactory {
        SelfStudyCheckComponent(parent: self)
    }
    var classroomMoveListFactory: any ClassroomMoveListFactory {
        ClassroomMoveListComponent(parent: self)
    }
    var outingHistoryFactory: any OutingHistoryFactory {
        OutingHistoryComponent(parent: self)
    }
    var resignFactory: any ResignFactory {
        ResignComponent(parent: self)
    }
}
