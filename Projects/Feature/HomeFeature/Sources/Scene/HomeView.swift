import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import HomeDomainInterface
import Utility

public struct HomeView: View {
    let store: StoreOf<HomeReducer>
    
    public init(store: StoreOf<HomeReducer>) {
        self.store = store
    }
    
    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ScrollView {
                VStack(spacing: 24) {
                    SelfStudyView(
                        adminMessage: viewStore.adminSelfStudyTeacher
                    )
                    .frame(maxWidth: .infinity)
                    .frame(height: 72)
                    
                    TodayTimeTableView(schedules: [
                        Schedule(period: 2, subject: "2학년 2반"),
                        Schedule(period: 3, subject: "2학년 2반"),
                        Schedule(period: 5, subject: "2학년 2반"),
                        Schedule(period: 6, subject: "2학년 2반")
                    ])
                    
                    AllSelfStudyView(selfStudyDirector: viewStore.selfStudyDirector)
                        .frame(maxWidth: .infinity)
                }
                .padding(.horizontal, 24)
                .padding(.top, 24)
                .padding(.bottom, 24)
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    PiCKNavigationBar()
                        .padding(.leading, 8)
                }
            }
            .onAppear {
                viewStore.send(.fetchSelfStudyDirector(date: Date.todayString()))
                viewStore.send(.fetchAdminSelfStudyInfo)
            }
        }
    }
}
