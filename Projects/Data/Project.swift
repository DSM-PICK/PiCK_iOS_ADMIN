import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Data",
    product: .staticFramework,
    includeTargets: [.unitTest],
    dependencies: [
        .Projects.domain,
        .Modules.appNetwork
    ]
)
