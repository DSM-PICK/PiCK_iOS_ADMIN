import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "HomeFeature",
    interfaceSources: ["Interface/HomeFeatureInterface.swift"],
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.homeDomainInterface,
        .Projects.acceptDomainInterface,
        .Projects.allTabDomainInterface,
        .Projects.classroomMoveListDomainInterface,
        .Projects.outListDomainInterface,
        .Features.planFeatureInterface,
        .Features.acceptFeatureInterface,
        .Features.allTabFeatureInterface,
        .Features.schoolMealFeatureInterface,
        .Shared.utility,
        .Shared.thirdPartyLib
    ],
    testDependencies: [
        .Projects.homeDomainInterface,
        .Projects.acceptDomainInterface,
        .Projects.classroomMoveListDomainInterface,
        .Projects.outListDomainInterface
    ]
)
