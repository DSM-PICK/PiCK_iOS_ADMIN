import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "SignupFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.authDomainInterface,
        .SPM.ComposableArchitecture,
        .Shared.thirdPartyLib,
    ],
    testDependencies: [
        .Projects.authDomainInterface,
    ]
)
