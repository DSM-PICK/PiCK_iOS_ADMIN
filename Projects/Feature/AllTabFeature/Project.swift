import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "AllTabFeature",
    interfaceSources: ["Interface/AllTabFeatureInterface.swift"],
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.allTabDomainInterface,
        .Projects.changePasswordDomainInterface,
        .Projects.classroomMoveListDomainInterface,
        .Projects.outListDomainInterface,
        .Projects.outingHistoryDomainInterface,
        .Features.homeFeature,
        .Features.checkSelfStudyTeacherFeature,
        .Features.bugReportFeature,
        .Features.changePasswordFeature,
        .Features.changePasswordFeatureInterface,
        .Features.classroomMoveListFeature,
        .Features.classroomMoveListFeatureInterface,
        .Features.outListFeature,
        .Features.outListFeatureInterface,
        .Features.outingHistoryFeature,
        .Features.outingHistoryFeatureInterface,
        .Features.selfStudyCheckFeature,
        .Shared.utility,
        .Shared.thirdPartyLib
    ]
)
