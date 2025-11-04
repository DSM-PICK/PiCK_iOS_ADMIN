import SwiftUI
import ComposableArchitecture
import PlanFeatureInterface
import PlanDomainInterface

public struct PlanComponentImpl: PlanFactory {
    private let fetchMonthAcademicScheduleUseCase: FetchMonthAcademicScheduleUseCaseProtocol
    private let fetchAcademicScheduleUseCase: FetchAcademicScheduleUseCaseProtocol
    
    public init(
        fetchMonthAcademicScheduleUseCase: FetchMonthAcademicScheduleUseCaseProtocol,
        fetchAcademicScheduleUseCase: FetchAcademicScheduleUseCaseProtocol
    ) {
        self.fetchMonthAcademicScheduleUseCase = fetchMonthAcademicScheduleUseCase
        self.fetchAcademicScheduleUseCase = fetchAcademicScheduleUseCase
    }
    
    public func makePlanView() -> AnyView {
        let store = Store(
            initialState: PlanReducer.State(),
            reducer: {
                PlanReducer(
                    fetchMonthAcademicScheduleUseCase: fetchMonthAcademicScheduleUseCase,
                    fetchAcademicScheduleUseCase: fetchAcademicScheduleUseCase
                )
            }
        )
        
        return AnyView(PlanFeature(store: store))
    }
}
