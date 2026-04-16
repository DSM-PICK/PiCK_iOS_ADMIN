import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "OnboardingFeature",
    interfaceSources: ["Interface/OnboardingFeatureInterface.swift"],
    includeUnitTests: true,
    implementationDependencies: [
        .Shared.utility,
        .Shared.thirdPartyLib,
    ]
)
