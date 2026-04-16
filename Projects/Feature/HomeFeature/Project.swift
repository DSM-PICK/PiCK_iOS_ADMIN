import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "HomeFeature",
    interfaceSources: ["Interface/HomeFeatureInterface.swift"],
    implementationDependencies: [
        .Projects.homeDomainInterface,
        .Features.planFeatureInterface,
        .Features.allTabFeatureInterface,
        .Features.schoolMealFeatureInterface,
        .Shared.utility,
        .Shared.thirdPartyLib,
    ]
)
