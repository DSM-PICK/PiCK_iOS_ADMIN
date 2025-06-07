import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "PiCK_iOS_ADMIN",
    organizationName: "com.pick",
    packages: [],
    settings: .settings(
        base: [:],
        configurations: [
            .debug(name: "Debug"),
            .release(name: "Release")
        ]
    ),
    targets: [
        Target(
            name: "PiCK_iOS_ADMIN",
            platform: .iOS,
            product: .app,
            bundleId: "com.pick.PiCK_iOS_ADMIN",
            deploymentTarget: .iOS(targetVersion: "15.0", devices: .iphone),
            infoPlist: .default,
            sources: ["PiCK_iOS_ADMIN/Sources/**"],
            resources: ["PiCK_iOS_ADMIN/Resources/**"],
            dependencies: []
        )
    ]
) 