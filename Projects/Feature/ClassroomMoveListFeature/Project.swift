import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "ClassroomMoveListFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.classroomMoveListDomainInterface,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
        .Shared.thirdPartyLib,
    ],
    testDependencies: [
        .Projects.classroomMoveListDomainInterface,
    ]
)
