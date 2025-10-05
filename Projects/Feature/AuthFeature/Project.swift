import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let project = Project.makeFeature(
    name: "AuthFeature",
    sources: ["Sources/**", "Interface/**"],
    dependencies: [
        .Features.baseFeature
    ]
)
