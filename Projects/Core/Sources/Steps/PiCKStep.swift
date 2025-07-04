import Foundation

import RxFlow

public enum PiCKStep: Step {
    case appIsRequired
    case onboardingIsRequired
    case loginIsRequired

    case tabIsRequired
}
