import SchoolMealDomainInterface
import ComposableArchitecture
import Combine
import Foundation

public struct SchoolMealReducer: Reducer {
    private let fetchSchoolMealsUseCase: FetchSchoolMealUseCaseProtocol

    public init(fetchSchoolMealsUseCase: FetchSchoolMealUseCaseProtocol) {
        self.fetchSchoolMealsUseCase = fetchSchoolMealsUseCase
    }

    public struct State: Equatable {
        public var selectedDate: Date = Date()
        public var mealData: SchoolMealEntity?
        public var isLoading: Bool = false
        public var errorMessage: String?
        
        public init() {}
    }
    
    public enum Action {
        case onAppear
        case dateChanged(Date)
        case fetchMeal(String)
        case mealFetched(SchoolMealEntity)
        case fetchFailed(String)
    }
    
    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let dateString = formatDate(state.selectedDate)
                return .send(.fetchMeal(dateString))
                
            case .dateChanged(let date):
                state.selectedDate = date
                let dateString = formatDate(date)
                return .send(.fetchMeal(dateString))
                
            case .fetchMeal(let dateString):
                state.isLoading = true
                state.errorMessage = nil
                return .publisher {
                    fetchSchoolMealsUseCase.execute(date: dateString)
                        .mapError { $0 as Error }
                        .map { Action.mealFetched($0) }
                        .catch { Just(Action.fetchFailed($0.localizedDescription)) }
                }
                
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
}
