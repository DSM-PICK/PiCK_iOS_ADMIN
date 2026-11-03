import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "OutListFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.outListDomainInterface,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
        .Shared.utility,
        .Shared.thirdPartyLib
    ],
    testDependencies: [
        .Projects.outListDomainInterface,
        .Shared.utility
    ]
)
