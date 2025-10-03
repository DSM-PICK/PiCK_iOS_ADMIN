import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: "BaseFeature",
    sources: ["Sources/**", "Interface/**"],
    dependencies: [
        .Projects.core,
        .Projects.authDomain,
        .Shared.utility
    ]
)
