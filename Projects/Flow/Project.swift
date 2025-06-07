import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "Flow",
    product: .staticLibrary,
    packages: [.FCM],
    includeTargets: [.unitTest],
    dependencies: [
        .Projects.data,
        .Projects.presentation,
        .SPM.FCM
    ]
)
