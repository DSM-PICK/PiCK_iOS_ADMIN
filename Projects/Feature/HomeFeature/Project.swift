import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "HomeFeature",
    interfaceSources: ["Interface/HomeFeatureInterface.swift"],
    implementationDependencies: [
        .Projects.homeDomainInterface,
        .Projects.acceptDomainInterface,
        .Projects.classroomMoveListDomainInterface,
        .Projects.outListDomainInterface,
        .Features.acceptFeatureInterface,
        .Features.allTabFeatureInterface,
        .Features.planFeatureInterface,
        .Features.schoolMealFeatureInterface,
        .Shared.utility,
        .Shared.thirdPartyLib,
    ]
)
