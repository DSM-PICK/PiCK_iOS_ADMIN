import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeFeature(
    name: "BaseFeature",
    dependencies: [
        .Projects.core,
        .Projects.authDomain,
        .Shared.utility
    ]
)
