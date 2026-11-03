import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "SelfStudyCheckFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.selfStudyCheckDomainInterface,
        .Features.baseFeature,
        .Shared.utility,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture
    ],
    testDependencies: [
        .Shared.utility
    ]
)
