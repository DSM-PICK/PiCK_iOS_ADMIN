
import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let project = Project.makeModule(
    name: "Core",
    product: .staticFramework,
    sources: ["Sources/**"],
    dependencies: []
)
