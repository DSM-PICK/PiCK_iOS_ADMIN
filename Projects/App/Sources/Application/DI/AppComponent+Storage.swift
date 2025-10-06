import NeedleFoundation
import Core
import KeychainSwift

public extension AppComponent {

    var userDefault: any UserDefault {
        shared {
            UserDefaultStorage()
        }
    }
}
