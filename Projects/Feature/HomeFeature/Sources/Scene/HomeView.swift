import SwiftUI
import PiCK_iOS_DesignSystem

public struct HomeView: View {
    
    public init() {}
    
    public var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                SelfStudyView()
                    .frame(height: 72)
                
                TodayTimeTableView(schedules: [
                    Schedule(period: 2, subject: "2학년 2반"),
                    Schedule(period: 3, subject: "2학년 2반"),
                    Schedule(period: 5, subject: "2학년 2반"),
                    Schedule(period: 6, subject: "2학년 2반")
                ])
                .frame(height: 316)
            }
            .padding(.horizontal, 24)
            .padding(.top, 24)
        }
        .navigationBarBackButtonHidden(true)
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                PiCKNavigationBar()
                    .padding(.leading, 8)
            }
        }
        .toolbarBackground(.white, for: .navigationBar)
        .toolbarBackground(.visible, for: .navigationBar)
    }
}
