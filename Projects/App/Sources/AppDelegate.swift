import UIKit

import Core
import Data
import Presentation

import Swinject
import Firebase
import FirebaseMessaging
import Pulse

@main
final class AppDelegate: UIResponder, UIApplicationDelegate {

    static var container = Container()
    var assembler: Assembler!

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        // ✅ Firebase 초기화
//        FirebaseApp.configure()

        assembler = Assembler([
            KeychainAssembly(),
            DataSourceAssembly(),
            RepositoryAssembly(),
            UseCaseAssembly(),
            PresentationAssembly()
        ], container: AppDelegate.container)

        #if DEBUG
        // Disabled to prevent crash: "NSArray element failed to match the Swift Array Element type"
        // URLSessionProxyDelegate.enableAutomaticRegistration()
        #endif

        return true
    }

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}
}
