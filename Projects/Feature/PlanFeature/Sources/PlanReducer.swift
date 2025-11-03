import ComposableArchitecture
import PlanDomainInterface
import Foundation

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
        
        public init() {}
    }

    public enum Action {
        case fetchMonthAcademicSchedule(year: String, month: String)
        case monthAcademicScheduleResponse(TaskResult<AcademicScheduleEntity>)
        case fetchAcademicSchedule(date: String)
        case academicScheduleResponse(TaskResult<AcademicScheduleEntity>)
        case selectDate(Date)
        case changeMonth(Date)
    }

    public var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .fetchMonthAcademicSchedule(year, month):
                return .run { send in
                    await send(.monthAcademicScheduleResponse(
                        await TaskResult { 
                            try await fetchMonthAcademicScheduleUseCase.execute(
                                year: year,
                                month: month
                            )
                        }
                    ))
                }

            case let .monthAcademicScheduleResponse(.success(schedule)):
                state.monthAcademicSchedule = schedule
                return .none

            case let .monthAcademicScheduleResponse(.failure(error)):
                state.monthAcademicSchedule = []
                return .none

            case let .fetchAcademicSchedule(date):
                return .run { send in
                    await send(.academicScheduleResponse(
                        await TaskResult { 
                            try await fetchAcademicScheduleUseCase.execute(date: date)
                        }
                    ))
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
