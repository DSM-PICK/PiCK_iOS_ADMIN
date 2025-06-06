import ProjectDescription

let project = Project(
    name: "PiCK_iOS_ADMIN",
    targets: [
        .target(
            name: "PiCK_iOS_ADMIN",
            destinations: .iOS,
            product: .app,
            bundleId: "io.tuist.PiCK-iOS-ADMIN",
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
        ),
        .target(
            name: "PiCK_iOS_ADMINTests",
            destinations: .iOS,
            product: .unitTests,
            bundleId: "io.tuist.PiCK-iOS-ADMINTests",
            infoPlist: .default,
            sources: ["PiCK_iOS_ADMIN/Tests/**"],
            resources: [],
            dependencies: [.target(name: "PiCK_iOS_ADMIN")]
        ),
    ]
)
