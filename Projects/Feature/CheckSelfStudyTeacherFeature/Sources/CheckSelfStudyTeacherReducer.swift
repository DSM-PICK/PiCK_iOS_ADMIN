import ComposableArchitecture
import CheckSelfStudyTeacherDomainInterface
import Foundation
import Combine

public struct CheckSelfStudyTeacherReducer: Reducer {
    private let fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol

    public init(
        fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol
    ) {
        self.fetchSelfStudyTeacherUseCase = fetchSelfStudyTeacherUseCase
    }

    public struct State: Equatable {
        public var isLoading: Bool = false
        public var teachers: [SelfStudyTeacherEntity] = []
        public var selectedDate: Date = Date()

        public init() {}
    }

    public enum Action {
        case onAppear
        case dateSelected(Date)
        case fetchSelfStudyTeacher(String)
        case selfStudyTeacherResponse(Result<[SelfStudyTeacherEntity], Error>)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .onAppear:
                let dateString = formatDate(state.selectedDate)
                return .send(.fetchSelfStudyTeacher(dateString))

            case let .dateSelected(date):
                state.selectedDate = date
                let dateString = formatDate(date)
                return .send(.fetchSelfStudyTeacher(dateString))

            case let .fetchSelfStudyTeacher(date):
                state.isLoading = true
                return .publisher {
                    fetchSelfStudyTeacherUseCase.execute(date: date)
                        .mapError { $0 as Error }
                        .map { Action.selfStudyTeacherResponse(.success($0)) }
                        .catch { Just(Action.selfStudyTeacherResponse(.failure($0))) }
                }

            case let .selfStudyTeacherResponse(.success(teachers)):
                state.teachers = teachers
                state.isLoading = false
                return .none

            case .selfStudyTeacherResponse(.failure):
                state.isLoading = false
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
