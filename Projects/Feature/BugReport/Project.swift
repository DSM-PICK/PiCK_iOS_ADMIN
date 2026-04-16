import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "BugReportFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.bugReportDomainInterface,
        .Shared.utility,
        .SPM.PDS,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
    ],
    testDependencies: [
        .Projects.bugReportDomainInterface,
        .Shared.utility,
    ]
)
