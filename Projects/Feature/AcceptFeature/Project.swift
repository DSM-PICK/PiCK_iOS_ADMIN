import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "AcceptFeature",
    interfaceProduct: .staticLibrary,
    implementationDependencies: [
        .Projects.acceptDomainInterface,
        .Features.homeFeature,
        .Shared.utility,
        .Shared.thirdPartyLib,
    ]
)
