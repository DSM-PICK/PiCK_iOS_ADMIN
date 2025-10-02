import ProjectDescription
import ProjectDescriptionHelpers

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
        .SPM.kingfisher,
        .SPM.KeychainSwift,
        .SPM.ReactorKit,
        .SPM.RxGesture,
        .SPM.Pulse,
        .SPM.PulseUI,
        .SPM.ComposableArchitecture
    ]
)
