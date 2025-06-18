import ReactorKit
import RxSwift
import RxCocoa
import Domain

public final class SignUpReactor: BaseReactor, Stepper {
    public let steps = PublishRelay<Step>()
    
}
