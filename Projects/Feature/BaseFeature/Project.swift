import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let project = Project.makeFeature(
    name: "BaseFeature",
    sources: ["Sources/**", "Interface/**"],
    dependencies: [
        .Projects.core,
        .Projects.authDomain,
        .Shared.utility
    ]
)
