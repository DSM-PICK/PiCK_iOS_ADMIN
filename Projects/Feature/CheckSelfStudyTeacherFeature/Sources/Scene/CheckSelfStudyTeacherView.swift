import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import BaseFeature
import CheckSelfStudyTeacherDomainInterface

public struct CheckSelfStudyTeacherView: View {
    @Environment(\.dismiss) var dismiss
    let store: StoreOf<CheckSelfStudyTeacherReducer>
    @State private var selectedDate = Date()
    @State private var currentPage = Date()
    @State private var isWeekMode = true

    public init(store: StoreOf<CheckSelfStudyTeacherReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(store, observe: { $0 }) { viewStore in
            ZStack {
                Color.Background.background
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 0) {
                    titleView(selectedDate: viewStore.selectedDate)
                        .padding(.top, 32)
                        .padding(.leading, 24)

                    if !viewStore.teachers.isEmpty {
                        teacherListView(teachers: viewStore.teachers)
                            .padding(.leading, 24)
                            .padding(.top, 32)
                    }

                    Spacer()
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                if viewStore.teachers.isEmpty {
                    VStack {
                        Spacer()
                        Text("등록된 자습 감독 선생님이 없습니다.")
                            .pickText(type: .body1, textColor: .Normal.black)
                        Spacer()
                        Spacer()
                    }
                }

                VStack {
                    Spacer()

                    PiCKCalendarView(
                        calendarType: .selfStudy,
                        selectedDate: $selectedDate,
                        currentPage: $currentPage,
                        isWeekMode: $isWeekMode,
                        dateSelected: { date in
                            selectedDate = date
                            viewStore.send(.dateSelected(date))
                        }
                    )
                }
                .ignoresSafeArea(edges: .bottom)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar(.hidden, for: .tabBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20, weight: .semibold))
                            .foregroundColor(.Normal.black)
                    }
                }

                ToolbarItem(placement: .principal) {
                    Text("자습 감독 선생님 확인")
                        .pickText(type: .subTitle1, textColor: .Normal.black)
                }
            }
            .onAppear {
                viewStore.send(.onAppear)
            }
        }
    }

    @ViewBuilder
    private func titleView(selectedDate: Date) -> some View {
        let isToday = Calendar.current.isDateInToday(selectedDate)
        let dateString = formatDateString(selectedDate)

        VStack(alignment: .leading, spacing: 0) {
            if isToday {
                Text(dateString + ",")
                    .pickText(type: .heading4, textColor: .Normal.black)
                HStack(spacing: 0) {
                    Text("오늘의 자습 감독")
                        .pickText(type: .heading4, textColor: .Primary.primary500)
                    Text(" 선생님입니다.")
                        .pickText(type: .heading4, textColor: .Normal.black)
                }
            } else {
                Text(dateString + "의")
                    .pickText(type: .heading4, textColor: .Primary.primary500)
                Text("자습 감독 선생님입니다.")
                    .pickText(type: .heading4, textColor: .Normal.black)
            }
        }
    }

    @ViewBuilder
    private func teacherListView(teachers: [SelfStudyTeacherEntity]) -> some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 32) {
                ForEach(teachers) { teacher in
                    Text("\(teacher.floor)층")
                        .pickText(type: .body1, textColor: .Gray.gray800)
                }
            }

            VStack(alignment: .leading, spacing: 32) {
                ForEach(teachers) { teacher in
                    Text("\(teacher.teacherName) 선생님")
                        .pickText(type: .body1, textColor: .Normal.black)
                }
            }

            Spacer()
        }
    }

    private func formatDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        return formatter.string(from: date)
    }
}
