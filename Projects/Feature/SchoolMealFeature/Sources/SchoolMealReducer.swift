import SchoolMealDomainInterface
import ComposableArchitecture
import Combine
import Foundation

@Reducer
public struct SchoolMealReducer: Reducer {
    private let fetchSchoolMealsUseCase: FetchSchoolMealUseCaseProtocol

    public init(fetchSchoolMealsUseCase: FetchSchoolMealUseCaseProtocol) {
        self.fetchSchoolMealsUseCase = fetchSchoolMealsUseCase
    }

    @ObservableState
    public struct State: Equatable {
        public var selectedDate: Date = Date()
        public var mealData: SchoolMealEntity?
        public var isLoading: Bool = false
        public var errorMessage: String?
        public var lastRequestedDate: Date?

        public init() {}
    }

    public enum Action: BindableAction {
        case binding(BindingAction<State>)
        case onAppear
        case mealFetched(SchoolMealEntity)
        case fetchFailed(String)
    }

    private enum CancelID {
        case fetchMeal
    }

    public var body: some ReducerOf<Self> {
        BindingReducer()

        Reduce { state, action in
            switch action {
            case .binding, .onAppear:
                return startFetchIfNeeded(for: state.selectedDate, state: &state)

            case .mealFetched(let mealEntity):
                state.isLoading = false
                state.mealData = mealEntity
                return .none

            case .fetchFailed(let error):
                state.isLoading = false
                state.errorMessage = error
                return .none
            }
        }
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: date)
    }

    private func startFetchIfNeeded(for date: Date, state: inout State) -> Effect<Action> {
        guard state.lastRequestedDate != date else { return .none }

        state.isLoading = true
        state.errorMessage = nil
        state.lastRequestedDate = date

        let dateString = formatDate(date)

        return .publisher {
            fetchSchoolMealsUseCase.execute(date: dateString)
                .map(Action.mealFetched)
                .catch { Just(Action.fetchFailed($0.localizedDescription)) }
        }
        .cancellable(id: CancelID.fetchMeal, cancelInFlight: true)
    }
}
