import Foundation
import UIKit
import Core
import SnapKit
import RxGesture
import Then

final class PiCKRequestButton: BaseButton {
    public var buttonTap: ControlEvent<Void> {
        return self.rx.tap
    }
    private let button 
    override func layoutSubviews() {
    
    }
}
