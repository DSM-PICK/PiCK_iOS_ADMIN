import SwiftUI
import ComposableArchitecture
import PlanFeatureInterface
import PlanDomainInterface

public class PlanComponentImpl: PlanFactory {
    private let fetchMonthAcademicScheduleUseCase: FetchMonthAcademicScheduleUseCaseProtocol
    private let fetchAcademicScheduleUseCase: FetchAcademicScheduleUseCaseProtocol

    private lazy var store: StoreOf<PlanReducer> = {
        Store(
            initialState: PlanReducer.State(),
            reducer: {
                PlanReducer(
                    fetchMonthAcademicScheduleUseCase: fetchMonthAcademicScheduleUseCase,
                    fetchAcademicScheduleUseCase: fetchAcademicScheduleUseCase
                )
            }
        )
    }()

    public init(
        fetchMonthAcademicScheduleUseCase: FetchMonthAcademicScheduleUseCaseProtocol,
        fetchAcademicScheduleUseCase: FetchAcademicScheduleUseCaseProtocol
    ) {
        self.fetchMonthAcademicScheduleUseCase = fetchMonthAcademicScheduleUseCase
        self.fetchAcademicScheduleUseCase = fetchAcademicScheduleUseCase
    }

    public func makePlanView() -> AnyView {
        return AnyView(PlanFeature(store: store))
    }
}
