import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "BugReportFeature",
    implementationDependencies: [
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture
    ]
)
