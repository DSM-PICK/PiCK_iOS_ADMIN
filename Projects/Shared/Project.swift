import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let project = Project.makeModule(
    name: "Shared",
    product: .staticFramework,
    sources: [],
    dependencies: [
        .Shared.thirdPartyLib,
        .Shared.utility
    ]
)