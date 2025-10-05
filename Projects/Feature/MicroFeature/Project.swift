import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let project = Project.makeFeature(
    name: "MicroFeature",
    sources: ["Sources/**", "Interface/**"],
    dependencies: [
        .Features.baseFeature
    ]
)
