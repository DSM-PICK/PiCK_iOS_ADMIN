import SwiftUI
import Core

@main
struct PiCK_iOS_ADMINApp: App {
    
    init() {
        registerProviderFactories()
    }

    var body: some Scene {
        WindowGroup {
            AppComponent(keychain: KeychainImpl()).makeRootView()
        }
    }
}
