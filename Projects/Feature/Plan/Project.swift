import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin

let project = Project.makeFeatureModule(
    name: "PlanFeature",
    interfaceSources: ["Interface/PlanInterface.swift"],
    includeUnitTests: true,
    implementationDependencies: [
        .Shared.thirdPartyLib,
    ]
)
