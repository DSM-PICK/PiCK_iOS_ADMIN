import ProjectDescriptionHelpers
import ProjectDescription
import DependencyPlugin
import EnvironmentPlugin
import ConfigurationPlugin
import Foundation

let isCI: Bool = (ProcessInfo.processInfo.environment["TUIST_CI"] ?? "0") == "1"

let configurations: [Configuration] = [
    .debug(name: .dev, xcconfig: .relativeToXCConfig(type: .dev, name: env.targetName)),
    .debug(name: .stage, xcconfig: .relativeToXCConfig(type: .stage, name: env.targetName)),
    .release(name: .prod, xcconfig: .relativeToXCConfig(type: .prod, name: env.targetName))
]

let settings: Settings = .settings(
    base: env.baseSetting,
    configurations: configurations,
    defaultSettings: .recommended
)

let scripts: [TargetScript] = isCI ? [] : [.swiftLint]


let targets: [Target] = [
    .target(
        name: env.targetName,
        destinations: env.destination,
        product: .app,
        bundleId: "$(APP_BUNDLE_ID)",
        deploymentTargets: env.deploymentTargets,
        infoPlist: .file(path: "Support/Info.plist"),
        sources: .sources,
        resources: .resources,
        entitlements: "Support/\(env.appName).entitlements",
        scripts: scripts,
        dependencies: [
            .Projects.flow
        ],
        settings: .settings(base: env.baseSetting)
    ),
]

let schemes: [Scheme] = [
    .scheme(
        name: "\(env.targetName)-DEV",
        shared: true,
        buildAction: .buildAction(targets: [TargetReference(stringLiteral: env.targetName)]),
        testAction: .targets(
            [TestableTarget(stringLiteral: env.targetName)],
            configuration: .dev,
            options: .options(
                coverage: true,
                codeCoverageTargets: [TargetReference(stringLiteral: env.targetName)]
            )
        ),
        runAction: .runAction(configuration: .dev),
        archiveAction: .archiveAction(configuration: .dev),
        profileAction: .profileAction(configuration: .dev),
        analyzeAction: .analyzeAction(configuration: .dev)
    ),
    .scheme(
        name: "\(env.targetName)-PROD",
        shared: true,
        buildAction: .buildAction(targets: [TargetReference(stringLiteral: env.targetName)]),
        testAction: nil,
        runAction: .runAction(configuration: .prod),
        archiveAction: .archiveAction(configuration: .prod),
        profileAction: .profileAction(configuration: .prod),
        analyzeAction: .analyzeAction(configuration: .prod)
    ),
    .scheme(
        name: "\(env.targetName)-STAGE",
        shared: true,
        buildAction: .buildAction(targets: [TargetReference(stringLiteral: env.targetName)]),
        testAction: nil,
        runAction: .runAction(configuration: .stage),
        archiveAction: .archiveAction(configuration: .stage),
        profileAction: .profileAction(configuration: .stage),
        analyzeAction: .analyzeAction(configuration: .stage)
    )
]

let project = Project(
    name: env.targetName,
    organizationName: env.organizationName,
    packages: [],
    settings: settings,
    targets: targets,
    schemes: schemes
)
