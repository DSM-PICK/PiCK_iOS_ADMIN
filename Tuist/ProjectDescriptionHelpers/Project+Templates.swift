import Foundation
import ProjectDescription
import DependencyPlugin
import EnvironmentPlugin
import ConfigurationPlugin

let isCI = (ProcessInfo.processInfo.environment["TUIST_CI"] ?? "0") == "1" ? true : false

public enum ModuleTarget {
    case unitTest
    case demo
}

public extension Project {
    static func makeFeature(
        name: String,
        product: Product = .staticFramework,
        includeTargets: Set<ModuleTarget> = [],
        sources: SourceFilesList = .sources,
        dependencies: [TargetDependency] = []
    ) -> Project {
        return makeModule(
            name: name,
            product: product,
            sources: sources,
            includeTargets: includeTargets,
            dependencies: dependencies
        )
    }

    static func makeShared(
        name: String,
        product: Product = .staticFramework,
        settings: SettingsDictionary = [:],
        dependencies: [TargetDependency] = []
    ) -> Project {
        return makeModule(
            name: name,
            product: product,
            dependencies: dependencies,
            settings: settings
        )
    }

    public static func makeModule(
        name: String,
        product: Product,
        organizationName: String = env.organizationName,
        sources: SourceFilesList = .sources,
        resources: ResourceFileElements? = nil,
        resourceSynthesizers: [ResourceSynthesizer] = .default + [],
        destination: Destinations = env.destination,
        packages: [Package] = [],
        deploymentTarget: DeploymentTargets = env.deploymentTargets,
        includeTargets: Set<ModuleTarget> = [],
        dependencies: [TargetDependency] = [],
        settings: SettingsDictionary = [:],
        configurations: [Configuration] = [],
        additionalPlistRows: [String: ProjectDescription.Plist.Value] = [:]
    ) -> Project {

        let scripts: [TargetScript] = isCI ? [] : [.swiftLint]

        let ldFlagsSettings: SettingsDictionary = product == .framework ?
        ["OTHER_LDFLAGS": .string("$(inherited) -all_load")] :
        ["OTHER_LDFLAGS": .string("$(inherited)")]

        let configurations: [Configuration] = 
        [
          .debug(name: .dev),
          .debug(name: .stage),
          .release(name: .prod)
        ]
        /*
        isCI ?
        [
          .debug(name: .dev),
          .debug(name: .stage),
          .release(name: .prod)
        ] :
        [
          .debug(name: .dev, xcconfig: .relativeToXCConfig(type: .dev, name: name)),
          .debug(name: .stage, xcconfig: .relativeToXCConfig(type: .stage, name: name)),
          .release(name: .prod, xcconfig: .relativeToXCConfig(type: .prod, name: name))
        ]
        */

        let settings: Settings = .settings(
            base: env.baseSetting
                .merging(.codeSign)
                .merging(settings)
                .merging(ldFlagsSettings),
            configurations: configurations,
            defaultSettings: .recommended
        )

        var allTargets: [Target] = [
            .target(
                name: name,
                destinations: destination,
                product: product,
                bundleId: "\(organizationName).\(name)",
                deploymentTargets: deploymentTarget,
                infoPlist: .extendingDefault(with: additionalPlistRows),
                sources: sources,
                resources: resources,
                scripts: scripts,
                dependencies: dependencies
            )
        ]

        if includeTargets.contains(.unitTest) {
            allTargets.append(
                .target(
                    name: "\(name)Tests",
                    destinations: destination,
                    product: .unitTests,
                    bundleId: "\(organizationName).\(name)Tests",
                    deploymentTargets: deploymentTarget,
                    infoPlist: .default,
                    sources: .unitTests,
                    scripts: scripts,
                    dependencies: []
                )
            )
        }

        if includeTargets.contains(.demo) {
            let demoDependencies: [TargetDependency] = [.target(name: name)]
            allTargets.append(
                .target(
                    name: "\(name)DemoApp",
                    destinations: destination,
                    product: .app,
                    bundleId: "\(organizationName).\(name)DemoApp",
                    deploymentTargets: deploymentTarget,
                    infoPlist: .extendingDefault(with: [
                        "UIMainStoryboardFile": "",
                        "UILaunchStoryboardName": "LaunchScreen",
                        "ENABLE_TESTS": .boolean(true),
                    ]),
                    sources: .demoSources,
                    resources: .demoResources,
                    scripts: scripts,
                    dependencies: demoDependencies
                )
            )
        }

        let schemes: [Scheme] = includeTargets.contains(.demo) ?
        [.makeScheme(target: .dev, name: name), .makeDemoScheme(target: .dev, name: name)] :
        [.makeScheme(target: .dev, name: name)]

        return Project(
            name: name,
            organizationName: organizationName,
            packages: packages,
            settings: settings,
            targets: allTargets,
            schemes: schemes,
            resourceSynthesizers: resourceSynthesizers
        )
    }
}

public extension Scheme {
    static func makeScheme(target: ConfigurationName, name: String, preActions: [ExecutionAction] = []) -> Scheme {
        return .scheme(
            name: name,
            shared: true,
            buildAction: .buildAction(targets: ["\(name)"], preActions: preActions),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }

    public static func makeDemoScheme(target: ConfigurationName, name: String) -> Scheme {
        return .scheme(
            name: "\(name)DemoApp",
            shared: true,
            buildAction: .buildAction(targets: ["\(name)DemoApp"]),
            testAction: .targets(
                ["\(name)Tests"],
                configuration: target,
                options: .options(coverage: true, codeCoverageTargets: ["\(name)DemoApp"])
            ),
            runAction: .runAction(configuration: target),
            archiveAction: .archiveAction(configuration: target),
            profileAction: .profileAction(configuration: target),
            analyzeAction: .analyzeAction(configuration: target)
        )
    }
}
