import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Presentation",
    product: .staticLibrary,
    includeTargets: [.unitTest],
    dependencies: [
        .Projects.domain,
        .Modules.designSystem
    ]
)
