import SwiftUI
import Core

@main
struct PiCK_iOS_ADMINApp: App {
    
    let appComponent: AppComponent

    init() {
        registerProviderFactories()
        self.appComponent = AppComponent(keychain: KeychainImpl())
    }

    var body: some Scene {
        WindowGroup {
            RootView(appComponent: appComponent)
        }
    }
}
