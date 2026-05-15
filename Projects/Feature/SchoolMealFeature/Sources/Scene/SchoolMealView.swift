import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

public struct SchoolMealView: View {
    @Perception.Bindable var store: StoreOf<SchoolMealReducer>
    @State private var currentPage = Date()
    @State private var isWeekMode = true
    private let impactFeedback = UIImpactFeedbackGenerator(style: .light)

    public init(store: StoreOf<SchoolMealReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            NavigationStack {
                ZStack(alignment: .top) {
                    ScrollView {
                        SelectedDateView(date: store.selectedDate)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .pickText(type: .heading4)
                            .padding(.horizontal, 24)
                            .padding(.top, 184)
                            .padding(.bottom, 20)

                        if store.isLoading {
                            ProgressView()
                                .padding(.top, 40)
                        } else if let mealData = store.mealData {
                            VStack(spacing: 20) {
                                ForEach(mealData.meals.mealBundle, id: \.0) { mealTime, mealInfo in
                                    SchoolMealCellView(
                                        mealTime: mealTime,
                                        menu: mealInfo.menu,
                                        kcal: mealInfo.kcal
                                    )
                                }
                            }
                            .padding(.horizontal, 24)
                            .padding(.bottom, 120)
                        } else if store.errorMessage != nil {
                            Text("급식 정보를 불러올 수 없습니다")
                                .pickText(type: .label1, textColor: .Normal.black)
                                .padding(.top, 40)
                        }
                    }
                    .ignoresSafeArea(edges: .bottom)
                    .overlay(
                        Group {
                            if !isWeekMode {
                                Color.black.opacity(0.4)
                                    .ignoresSafeArea()
                            }
                        }
                    )

                    PiCKCalendarView(
                        calendarType: .schoolMeal,
                        selectedDate: $store.selectedDate,
                        currentPage: $currentPage,
                        isWeekMode: $isWeekMode,
                        dateSelected: { _ in
                            impactFeedback.impactOccurred()
                        }
                    )
                    .shadow(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 0)
                    .background(Color.Background.background)
                    .frame(maxHeight: .infinity, alignment: .top)
                }
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        PiCKImage.pickLogo
                            .resizable()
                            .scaledToFit()
                            .frame(height: 20)
                            .padding(.leading, 8)
                    }
                }
                .onAppear {
                    store.send(.onAppear)
                }
            }
        }
    }
}
