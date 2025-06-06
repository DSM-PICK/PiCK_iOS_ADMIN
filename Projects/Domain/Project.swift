import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Domain",
    product: .staticFramework,
    includeTargets: [.unitTest],
    dependencies: [
        .Modules.utility
    ]
)
