import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "SchoolMealFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.schoolMealDomainInterface,
        .Features.homeFeature,
        .Shared.utility,
        .Shared.thirdPartyLib,
    ]
)
