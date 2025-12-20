import ComposableArchitecture
import PlanDomainInterface
import Foundation
import Combine

public struct PlanReducer: Reducer {
    private let fetchMonthAcademicScheduleUseCase: any FetchMonthAcademicScheduleUseCaseProtocol
    private let fetchAcademicScheduleUseCase: any FetchAcademicScheduleUseCaseProtocol

    public init(
        fetchMonthAcademicScheduleUseCase: any FetchMonthAcademicScheduleUseCaseProtocol,
        fetchAcademicScheduleUseCase: any FetchAcademicScheduleUseCaseProtocol
    ) {
        self.fetchMonthAcademicScheduleUseCase = fetchMonthAcademicScheduleUseCase
        self.fetchAcademicScheduleUseCase = fetchAcademicScheduleUseCase
    }

    public struct State: Equatable {
        public var monthAcademicSchedule: AcademicScheduleEntity = []
        public var academicSchedule: AcademicScheduleEntity = []
        public var selectedDate: Date = Date()
        public var currentMonth: Date = Date()
        public var hasLoadedInitialData: Bool = false

        public init() {}
    }

    public enum Action {
        case fetchMonthAcademicSchedule(year: String, month: String)
        case monthAcademicScheduleResponse(TaskResult<AcademicScheduleEntity>)
        case fetchAcademicSchedule(date: String)
        case academicScheduleResponse(TaskResult<AcademicScheduleEntity>)
        case selectDate(Date)
        case changeMonth(Date)
        case loadInitialData
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case .loadInitialData:
                guard !state.hasLoadedInitialData else {
                    return .none
                }
                state.hasLoadedInitialData = true
                let today = Date()
                state.selectedDate = today
                state.currentMonth = today
                let calendar = Calendar.current
                let year = String(calendar.component(.year, from: today))
                let month = monthFormatter.string(from: today)
                let dateString = dateFormatter.string(from: today)
                return .merge(
                    .send(.fetchMonthAcademicSchedule(year: year, month: month)),
                    .send(.fetchAcademicSchedule(date: dateString))
                )

            case let .fetchMonthAcademicSchedule(year, month):
                return .publisher {
                    fetchMonthAcademicScheduleUseCase.execute(year: year, month: month)
                        .mapError { $0 as Error }
                        .map { Action.monthAcademicScheduleResponse(.success($0)) }
                        .catch { Just(Action.monthAcademicScheduleResponse(.failure($0))) }
                }

            case let .monthAcademicScheduleResponse(.success(schedule)):
                state.monthAcademicSchedule = schedule
                return .none

            case let .monthAcademicScheduleResponse(.failure(error)):
                state.monthAcademicSchedule = []
                return .none

            case let .fetchAcademicSchedule(date):
                return .publisher {
                    fetchAcademicScheduleUseCase.execute(date: date)
                        .mapError { $0 as Error }
                        .map { Action.academicScheduleResponse(.success($0)) }
                        .catch { Just(Action.academicScheduleResponse(.failure($0))) }
                }

            case let .academicScheduleResponse(.success(schedule)):
                state.academicSchedule = schedule
                return .none

            case let .academicScheduleResponse(.failure(error)):
                return .none

            case let .selectDate(date):
                state.selectedDate = date
                let dateString = dateFormatter.string(from: date)
                return .send(.fetchAcademicSchedule(date: dateString))

            case let .changeMonth(date):
                state.currentMonth = date
                let calendar = Calendar.current
                let year = String(calendar.component(.year, from: date))
                let month = monthFormatter.string(from: date)
                return .send(.fetchMonthAcademicSchedule(year: year, month: month))
            }
        }
    }
    
    private var dateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter
    }
    
    private var monthFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        formatter.locale = Locale(identifier: "en_US")
        return formatter
    }
}
