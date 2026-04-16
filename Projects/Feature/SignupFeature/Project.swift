import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "SignupFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.authDomainInterface,
        .Shared.thirdPartyLib,
    ]
)
