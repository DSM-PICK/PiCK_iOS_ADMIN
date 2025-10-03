
import ProjectDescription
import ProjectDescriptionHelpers

let project = Project.makeModule(
    name: "AuthDomain",
    product: .staticFramework,
    dependencies: [
        .SPM.RxSwift,
        .SPM.RxMoya,
        .SPM.Moya,
        .Projects.core
    ]
)
