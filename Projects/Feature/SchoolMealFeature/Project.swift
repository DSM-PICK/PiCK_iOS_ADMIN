import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "SchoolMealFeature",
    implementationDependencies: [
        .Projects.schoolMealDomainInterface,
        .Features.homeFeature,
        .Shared.utility,
        .Shared.thirdPartyLib,
    ]
)
