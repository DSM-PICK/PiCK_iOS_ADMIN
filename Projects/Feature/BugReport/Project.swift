import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "BugReportFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
    ]
)
