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
        .Projects.authDomain,
        .Projects.homeDomain
    ]
)