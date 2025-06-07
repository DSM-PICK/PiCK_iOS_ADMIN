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
        .target(
            name: "PiCK_iOS_ADMIN",
            destinations: .iOS,
            product: .app,
            bundleId: "com.pick.PiCK-iOS-ADMIN",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchStoryboardName": "LaunchScreen.storyboard",
                    "UIApplicationSceneManifest": [
                        "UIApplicationSupportsMultipleScenes": false,
                        "UISceneConfigurations": [
                            "UIWindowSceneSessionRoleApplication": [
                                [
                                    "UISceneConfigurationName": "Default Configuration",
                                    "UISceneDelegateClassName": "$(PRODUCT_MODULE_NAME).SceneDelegate"
                                ],
                            ]
                        ]
                    ],
                ]
            ),
            sources: ["PiCK_iOS_ADMIN/Sources/**"],
            resources: ["PiCK_iOS_ADMIN/Resources/**"],
            dependencies: []
        )
    ]
)
