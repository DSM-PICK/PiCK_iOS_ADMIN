import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let project = Project.makeShared(
    name: "ThirdPartyLib",
    product: .framework,
    settings: ["DEFINES_MODULE": "NO"],
    dependencies: [
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.RxFlow,
        .SPM.Moya,
        .SPM.RxMoya,
        .SPM.Lottie,
        .SPM.kingfisher,
        .SPM.KeychainSwift,
        .SPM.ReactorKit,
        .SPM.RxGesture,
        .SPM.Pulse,
        .SPM.ComposableArchitecture
    ]
)
