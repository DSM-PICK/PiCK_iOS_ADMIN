import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "ChangePasswordFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
    ]
)
