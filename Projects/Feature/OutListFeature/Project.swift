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
        .Shared.thirdPartyLib
    ],
    testDependencies: [
        .Projects.outListDomainInterface
    ]
)
