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
        .Projects.changePasswordDomain,
        .Projects.acceptDomain,
        .Projects.outListDomain
        .Projects.acceptDomain,
        .Projects.testDomain,
        .Projects.teacherDomain,
        .Projects.checkSelfStudyTeacher
    ]
)
