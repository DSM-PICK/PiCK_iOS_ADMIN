import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "SchoolMealFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.schoolMealDomainInterface,
        .Shared.utility,
        .Shared.thirdPartyLib,
    ],
    testDependencies: [
        .Projects.schoolMealDomainInterface,
    ]
)
