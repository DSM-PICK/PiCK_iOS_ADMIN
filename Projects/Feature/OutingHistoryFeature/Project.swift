import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "OutingHistoryFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
    ]
)
