import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "OutListFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture
    ]
)
