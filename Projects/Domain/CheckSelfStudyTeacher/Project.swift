import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let configurations: [Configuration] = [
    .debug(name: .dev),
    .debug(name: .stage),
    .release(name: .prod)
]

let settings: Settings = .settings(
    base: env.baseSetting.merging(.codeSign),
    configurations: configurations,
    defaultSettings: .recommended
)

let interfaceTarget = Target.target(
    name: "CheckSelfStudyTeacherDomainInterface",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).CheckSelfStudyTeacherDomainInterface",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Interface/**"],
    dependencies: [
        .Projects.core,
        .Shared.thirdPartyLib
    ]
)

let implementationTarget = Target.target(
    name: "CheckSelfStudyTeacherDomain",
    destinations: env.destination,
    product: .framework,
    bundleId: "\(env.organizationName).CheckSelfStudyTeacherDomain",
    deploymentTargets: env.deploymentTargets,
    infoPlist: .default,
    sources: ["Sources/**"],
    dependencies: [
        .target(name: "CheckSelfStudyTeacherDomainInterface"),
        .Projects.baseDomain,
        .Shared.thirdPartyLib
    ]
)

let project = Project(
    name: "CheckSelfStudyTeacherDomain",
    organizationName: env.organizationName,
    settings: settings,
    targets: [interfaceTarget, implementationTarget]
)
