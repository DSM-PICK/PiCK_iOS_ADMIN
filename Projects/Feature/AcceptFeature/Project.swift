import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "AcceptFeature",
    interfaceProduct: .staticLibrary,
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.acceptDomainInterface,
        .Features.homeFeature,
        .Shared.utility,
        .Shared.thirdPartyLib,
    ],
    testDependencies: [
        .Projects.acceptDomainInterface,
    ]
)
