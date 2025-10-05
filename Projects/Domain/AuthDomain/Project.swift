
import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let project = Project.makeModule(
    name: "AuthDomain",
    product: .staticFramework,
    sources: ["Sources/**", "Interface/**"],
    dependencies: [
        .Shared.thirdPartyLib,
        .Projects.core
    ]
)
