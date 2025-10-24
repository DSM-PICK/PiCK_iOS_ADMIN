import SwiftUI
import Core
import BaseFeature

@main
struct PiCK_iOS_ADMINApp: App {
    
    let appComponent: AppComponent

    init() {
        registerProviderFactories()
        self.appComponent = AppComponent(keychain: KeychainImpl())
        BaseNavigation.configureAppearance()
    }

    var body: some Scene {
        WindowGroup {
            RootView(appComponent: appComponent)
        }
    }
}
