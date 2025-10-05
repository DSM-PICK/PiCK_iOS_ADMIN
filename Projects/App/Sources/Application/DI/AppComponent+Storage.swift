import NeedleFoundation
import KeychainModule
import UserDefaultModule

public extension AppComponent {
    var keychain: any Keychain {
        shared {
            KeychainImpl()
        }
    }

    var userDefault: any UserDefault {
        shared {
            UserDefaultStorage()
        }
    }
}
