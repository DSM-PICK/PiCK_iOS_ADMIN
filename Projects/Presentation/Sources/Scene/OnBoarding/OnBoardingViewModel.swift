import Foundation
import RxSwift
import RxCocoa
import RxFlow
import Core
import Domain

public class OnBoardingViewModel: BaseViewModel, Stepper {
    public var steps = PublishRelay<Step>()

    public struct Input {}
    public struct Output {}

    public init() {}

    public func transform(input: Input) -> Output {
        return Output()
    }
}
