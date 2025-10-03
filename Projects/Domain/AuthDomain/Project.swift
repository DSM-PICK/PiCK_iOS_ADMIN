
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "AuthDomain",
    product: .staticFramework,
    sources: ["Sources/**", "Interface/**"],
    dependencies: [
        .Shared.thirdPartyLib,
        .Projects.core
    ]
)
