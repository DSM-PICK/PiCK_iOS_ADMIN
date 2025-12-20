import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let project = Project.makeModule(
    name: "Domain",
    product: .staticFramework,
    sources: [],
    dependencies: [
        .Projects.baseDomain,
        .Projects.authDomain,
        .Projects.allTabDomain,
        .Projects.bugReportDomain,
        .Projects.changePasswordDomain,
        .Projects.acceptDomain,
        .Projects.selfStudyCheckDomain,
        .Projects.outingHistoryDomain,
        .Projects.classroomMoveListDomain,
        .Projects.outListDomain,
        .Projects.testDomain,
        .Projects.checkSelfStudyTeacher
    ]
)
