import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "Shared",
    product: .framework,
    dependencies: [
        .project(target: "ThirdPartyLib", path: .relativeToParent("ThirdPartyLib")),
        .project(target: "Utility", path: .relativeToParent("Utility")),
    ]
)
