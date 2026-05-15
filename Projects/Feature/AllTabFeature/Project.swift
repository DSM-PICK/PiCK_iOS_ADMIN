import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "AllTabFeature",
    interfaceSources: ["Interface/AllTabFeatureInterface.swift"],
    implementationDependencies: [
        .Projects.allTabDomainInterface,
        .Projects.authDomainInterface,
        .Features.bugReportFeatureInterface,
        .Features.checkSelfStudyTeacherFeatureInterface,
        .Features.changePasswordFeatureInterface,
        .Features.classroomMoveListFeatureInterface,
        .Features.outListFeatureInterface,
        .Features.outingHistoryFeatureInterface,
        .Features.selfStudyCheckFeatureInterface,
        .Shared.utility,
        .Shared.thirdPartyLib,
    ]
)
