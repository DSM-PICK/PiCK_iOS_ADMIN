import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Features",
    product: .framework,
    dependencies: [
        .project(target: "BaseFeature", path: .relativeToParent("BaseFeature"))
    ]
)
