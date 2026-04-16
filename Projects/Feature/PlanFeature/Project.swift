import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "PlanFeature",
    implementationDependencies: [
        .Projects.planDomainInterface,
        .Features.homeFeature,
        .Shared.utility,
        .Shared.thirdPartyLib,
    ]
)
