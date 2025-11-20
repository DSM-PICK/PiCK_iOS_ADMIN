import SwiftUI
import HomeFeature
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

public struct SchoolMealView: View {
    let store: StoreOf<SchoolMealReducer>
    @State private var selectedDate = Date()
    @State private var currentPage = Date()
    @State private var isWeekMode = true
    
    public init(store: StoreOf<SchoolMealReducer>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationView {
            ZStack(alignment: .top) {
                ScrollView {
                    SelectedDateView(date: selectedDate)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .pickText(type: .heading4)
                        .padding(.horizontal, 24)
                        .padding(.top, 184)
                        .padding(.bottom, 20)

                        VStack(spacing: 20) {
                            SchoolMealCellView(
                                mealTime: "중식",
                                menu: ["급식1", "우유", "과일"],
                                kcal: "450kcal"
                            )
                            SchoolMealCellView(
                                mealTime: "석식",
                                menu: [],
                                kcal: ""
                            )
                        }
                        .padding(.horizontal, 24)
                        .padding(.bottom, 120)
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
                    selectedDate: $selectedDate,
                    currentPage: $currentPage,
                    isWeekMode: $isWeekMode
                )
                .shadow(color: Color.black.opacity(0.25), radius: 20, x: 0, y: 0)
                .background(Color.Background.background)
                .frame(maxHeight: .infinity, alignment: .top)
                .allowsHitTesting(true)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    PiCKNavigationBar()
                        .padding(.leading, 8)
                }
            }
        }
    }
}
