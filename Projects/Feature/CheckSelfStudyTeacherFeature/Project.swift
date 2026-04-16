import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "CheckSelfStudyTeacherFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
    ]
)
