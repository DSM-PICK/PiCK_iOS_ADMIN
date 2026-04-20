import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "PlanFeature",
    includeUnitTests: true,
    implementationDependencies: [
        .Projects.planDomainInterface,
        .Shared.utility,
        .Shared.thirdPartyLib,
    ],
    testDependencies: [
        .Projects.planDomainInterface,
    ]
)
