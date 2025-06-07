import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeModule(
    name: "DesignSystem",
    resources: .resources,
    resourceSynthesizers: .default + [
        .custom(name: "Lottie", parser: .json, extensions: ["json"])
    ],
    product: .framework,
    includeTargets: [.demo],
    dependencies: [
        .Modules.utility
    ]
)
