import ProjectDescription

let config = Config(
    plugins: [
        .local(path: .relativeToRoot("Tuist/Plugins/DependencyPlugin")),
        .local(path: .relativeToRoot("Tuist/Plugins/ConfigurationPlugin")),
        .local(path: .relativeToRoot("Tuist/Plugins/EnvironmentPlugin"))
    ],
    generationOptions: .options()
)