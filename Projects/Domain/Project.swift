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
        .Projects.acceptDomain,,,,
        .Projects.changePasswordDomain
        .Projects.testDomain
        .Projects.teacherDomain
        .Projects.checkSelfStudyTeacher
    ]
)
