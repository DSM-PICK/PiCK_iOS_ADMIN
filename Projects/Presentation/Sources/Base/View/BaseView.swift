import UIKit
import Then
import SnapKit
import RxSwift
import RxCocoa

open class BaseButton: UIButton {

    public override init(frame: CGRect) {
        super.init(frame: frame)
        addView()
        bindAction()
    }
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    open override func layoutSubviews() {
        super.layoutSubviews()
        setLayout()
    }

    public func addView() {}

    public func setLayout() {}

    public func bindAction() {}

}
