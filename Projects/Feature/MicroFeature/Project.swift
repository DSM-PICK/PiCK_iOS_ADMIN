import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: "MicroFeature",
    dependencies: [
        .Features.baseFeature
    ]
)
