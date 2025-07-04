import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Core
import DesignSystem

public class OnboardingViewController: BaseViewController<OnboardingViewModel> {
    private let componentAppearRelay = PublishRelay<Void>()

    private let logoImageView = UIImageView(image: .onboardingLogo)
    private let onboardingButton = PiCKButton(buttonText: "로그인하고 PiCK 사용하기")

    public override func bind() {
        let input = OnboardingViewModel.Input(
            viewWillAppear: viewWillAppearPublisher.asObservable(),
            onboardingButtonDidTap: onboardingButton.buttonTap.asObservable()
        )
        let output = viewModel.transform(input: input)

        output.presentAlert.asObservable()
            .withUnretained(self)
            .bind { owner, _ in
                let alert = PiCKAlert(
                    titleText: "현재 서버가 점검중이에요",
                    explainText: "더욱 원활한 서비스 이용을 위해\n노력중이니 조금만 기다려주세요!\n확인버튼을 누르면 앱을 종료할게요.",
                    type: .positive
                ) {
                    UIApplication.shared.perform(#selector(NSXPCConnection.suspend))
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        exit(0)
                    }
                }
                owner.present(alert, animated: true)
            }.disposed(by: disposeBag)
    }

    public override func addView() {
        [
            logoImageView,
            onboardingButton
        ].forEach { view.addSubview($0) }
    }
    public override func setLayout() {
        logoImageView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(160)
            $0.height.equalTo(164)
        }
        onboardingButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(28)
        }
    }
}
