import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "SelfStudyCheckFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.selfStudyCheckDomainInterface,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
    ]
)
