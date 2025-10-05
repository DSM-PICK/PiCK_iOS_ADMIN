import ProjectDescription
import ProjectDescriptionHelpers
import DependencyPlugin
import ConfigurationPlugin
import EnvironmentPlugin

let project = Project.makeShared(
    name: "ThirdPartyLib",
    product: .framework,
    dependencies: [
        .SPM.RxSwift,
        .SPM.RxCocoa,
        .SPM.SnapKit,
        .SPM.Then,
        .SPM.RxFlow,
        .SPM.Swinject,
        .SPM.Moya,
        .SPM.RxMoya,
        .SPM.Lottie,
        .SPM.Kingfisher,
        .SPM.KeychainSwift,
        .SPM.ReactorKit,
        .SPM.RxGesture,
        .SPM.Pulse,
        .SPM.ComposableArchitecture
    ]
)
