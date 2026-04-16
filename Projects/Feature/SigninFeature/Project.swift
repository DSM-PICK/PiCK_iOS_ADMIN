import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "SigninFeature",
    interfaceSources: ["Interface/SigninFeatureInterface.swift"],
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.authDomainInterface,
        .Shared.thirdPartyLib
    ],
    testDependencies: [
        .Projects.authDomainInterface
    ]
)
