import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "CheckSelfStudyTeacherFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.checkSelfStudyTeacherDomainInterface,
        .SPM.NeedleFoundation,
        .SPM.ComposableArchitecture,
        .Shared.thirdPartyLib
    ],
    testDependencies: [
        .Projects.checkSelfStudyTeacherDomainInterface
    ]
)
