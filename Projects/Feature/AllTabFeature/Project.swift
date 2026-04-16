import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "AllTabFeature",
    interfaceSources: ["Interface/AllTabFeatureInterface.swift"],
    implementationDependencies: [
        .Projects.allTabDomainInterface,
        .Features.homeFeature,
        .Features.checkSelfStudyTeacherFeature,
        .Features.bugReportFeature,
        .Features.selfStudyCheckFeature,
        .Shared.utility,
        .Shared.thirdPartyLib,
    ]
)
