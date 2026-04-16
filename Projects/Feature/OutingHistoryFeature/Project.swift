import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "OutingHistoryFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.outingHistoryDomainInterface,
        .SPM.PDS,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
    ],
    testDependencies: [
        .Projects.outingHistoryDomainInterface,
    ]
)
