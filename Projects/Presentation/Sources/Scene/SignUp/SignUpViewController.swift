import UIKit
import SnapKit
import Then
import Core
import DesignSystem
import RxSwift
import RxCocoa

public final class SignUpViewController: BaseReactorViewController<SignUpReactor> {
    private let titleLabel = PiCKLabel(
        text: "PiCK에 회웝가입하기",
        textColor: .modeBlack,
        font: .pickFont(.heading2)
    ).then {
        $0.changePointColor(targetString: "PiCK", color: .main500)
    }

    private let explainLabel = PiCKLabel(
        text: "DSM 이메일로 인증 해주세요.",
        textColor: .gray600,
        font: .pickFont(.body1)
    )

    private let idTextField = PiCKTextField(
        titleText: "이메일",
        placeholder: "학교 이메일을 입력해주세요",
        buttonIsHidden: true
    )
    private let authorizationTextField = PiCKTextField(
        titleText: "인증 코드",
        placeholder: "인증 코드를 입력하세요",
        buttonIsHidden: false
    ).then {
        $0.isSecurity = true
    }
    private let loginButton = PiCKButton(
        buttonText: "다음",
        isHidden: false
    )

    public override func attribute() {
        super.attribute()

        navigationController?.interactivePopGestureRecognizer?.isEnabled = false
    }
    
    public override func addView() {
        [
            titleLabel,
            explainLabel,
            idTextField,
            loginButton
        ].forEach { view.addSubview($0) }
    }

    public override func setLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).inset(80)
            $0.leading.equalToSuperview().inset(24)
        }
        explainLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.equalToSuperview().inset(24)
        }
        idTextField.snp.makeConstraints {
            $0.top.equalTo(explainLabel.snp.bottom).offset(75)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(40)
        }
        loginButton.snp.makeConstraints {
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.bottom.equalTo(view.safeAreaLayoutGuide).inset(10)
        }
    }
}
