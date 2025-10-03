import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: "MicroFeature",
    sources: ["Sources/**", "Interface/**"],
    dependencies: [
        .Features.baseFeature
    ]
)
