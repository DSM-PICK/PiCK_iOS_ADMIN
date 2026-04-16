import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "ChangePasswordFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.authDomainInterface,
        .Projects.changePasswordDomainInterface,
        .Shared.utility,
        .SPM.PDS,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
    ],
    testDependencies: [
        .Projects.authDomainInterface,
    ]
)
