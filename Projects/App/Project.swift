
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
            scripts: [
                .pre(
                    script: "/opt/homebrew/bin/needle generate Sources/Application/DI/NeedleGenerated.swift Sources ../Feature",
                    name: "Run Needle",
                    outputPaths: ["Projects/App/Sources/Application/DI/NeedleGenerated.swift"]
                )
            ],
            dependencies: [
                .Features.baseFeature,
                .Features.signinFeature,
                .Features.signinFeatureInterface,
                .Features.signupFeature,
                .Features.signupFeatureInterface,
                .Features.onboardingFeature,
                .Features.onboardingFeatureInterface,
                .Features.homeFeature,
                .Features.homeFeatureInterface,
                .Projects.authDomainInterface,
                .Projects.homeDomainInterface,
                .Projects.core,
                .Shared.thirdPartyLib,
                .Shared.utility
            ]
        )
    ],
    schemes: [
        .makeScheme(target: .dev, name: "PiCK_iOS_ADMIN"),
        .makeScheme(target: .stage, name: "PiCK_iOS_ADMIN"),
        .makeScheme(target: .prod, name: "PiCK_iOS_ADMIN")
    ]
)
