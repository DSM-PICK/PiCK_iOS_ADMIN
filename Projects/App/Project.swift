
import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let project = Project(
    name: "PiCK_iOS_ADMIN",
    organizationName: env.organizationName,
    settings: .settings(
        base: env.baseSetting,
        configurations: [
            .debug(name: .dev),
            .debug(name: .stage),
            .release(name: .prod)
        ]
    ),
    targets: [
        .target(
            name: "PiCK_iOS_ADMIN",
            destinations: env.destination,
            product: .app,
            bundleId: "\(env.organizationName).PiCK-iOS-ADMIN",
            deploymentTargets: env.deploymentTargets,
            infoPlist: .file(path: "Support/Info.plist"),
            sources: ["Sources/**"],
            resources: ["Resources/**"],
            entitlements: .file(path: "Support/PiCK_iOS_ADMIN.entitlements"),
            dependencies: [
                .Features.baseFeature,
                .Features.microFeature,
                .Shared.thirdPartyLib,
                .SPM.FirebaseMessaging
            ]
        )
    ],
    schemes: [
        .makeScheme(target: .dev, name: "PiCK_iOS_ADMIN"),
        .makeScheme(target: .stage, name: "PiCK_iOS_ADMIN"),
        .makeScheme(target: .prod, name: "PiCK_iOS_ADMIN")
    ]
)
