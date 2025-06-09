import UIKit
import Network

import RxSwift
import RxCocoa

import Core
import DesignSystem

public class BaseReactorViewController<Reactor: BaseReactor>: UIViewController, UIGestureRecognizerDelegate {
    public let disposeBag = DisposeBag()
    public var reactor: Reactor

    public var viewWillAppearRelay = PublishRelay<Void>()

    public var navigationTitleText: String?

    public init(reactor: Reactor) {
        self.reactor = reactor
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func viewDidLoad() {
        super.viewDidLoad()
        attribute()
        bindAction()
        bindState()
        configureNavigationBar()
    }
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        viewWillAppearRelay.accept(())
    }
    open override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        addView()
        setLayout()
    }
    open override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        configureNavgationBarLayOutSubviews()
        setLayoutData()
    }

    open func attribute() {
        // 뷰 관련 코드를 설정하는 함수
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    open func configureNavigationBar() {
        // 네비게이션바 관련 코드를 설정하는 함수
    }
    open func configureNavgationBarLayOutSubviews() {
        // viewDidLayoutSubviews에서 네비게이션바 관련 코드를 호출하는 함수
        navigationController?.isNavigationBarHidden = false
    }
    open func bindAction() {}
    open func bindState() {}
    open func addView() {}
    open func setLayout() {}
    open func setLayoutData() {}

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }

}
