import UIKit

public extension UITextField {

    private func createPaddingView(width: CGFloat) -> UIView {
        return UIView(frame: CGRect(x: 0, y: 0, width: width, height: frame.height))
    }

    func addLeftPadding(_ width: CGFloat = 16) {
        leftView = createPaddingView(width: width)
        leftViewMode = .always
    }

    func addRightPadding(_ width: CGFloat = 16) {
        rightView = createPaddingView(width: width)
        rightViewMode = .always
    }

    func addHorizontalPadding(left: CGFloat = 16, right: CGFloat = 16) {
        addLeftPadding(left)
        addRightPadding(right)
    }

    func addHorizontalPadding(_ padding: CGFloat = 16) {
        addHorizontalPadding(left: padding, right: padding)
    }

    func removePadding() {
        leftView = nil
        rightView = nil
        leftViewMode = .never
        rightViewMode = .never
    }
}
