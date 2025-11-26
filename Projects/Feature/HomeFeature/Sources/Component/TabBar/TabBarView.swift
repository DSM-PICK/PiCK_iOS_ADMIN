import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import AllTabFeatureInterface
import PlanFeatureInterface
import SchoolMealFeatureInterface
import AcceptFeatureInterface

public struct TabBarView: View {
    @State private var selectedTab = 2
    let store: StoreOf<HomeReducer>
    let allTabFactory: any AllTabFactory
    let planFactory: any PlanFactory
    let schoolMealFactory: any SchoolMealFactory
    let acceptFactory: any AcceptFactory
    
    public init(
        store: StoreOf<HomeReducer>,
        allTabFactory: any AllTabFactory,
        planFactory: any PlanFactory,
        schoolMealFactory: any SchoolMealFactory
        acceptFactory: any AcceptFactory
    ) {
        self.store = store
        self.allTabFactory = allTabFactory
        self.planFactory = planFactory
        self.schoolMealFactory = schoolMealFactory
        self.acceptFactory = acceptFactory
    }
    
    public var body: some View {
        TabView(selection: $selectedTab) {
            schoolMealFactory.makeSchoolMealView()
                .tag(0)
                .tabItem {
                    Label {
                        Text("급식")
                            .pickText(type: .body3, textColor: .Normal.black)
                    } icon: {
                        PiCKImage.schoolMealIcon
                    }
                }
            
            planFactory.makePlanView()
                .tag(1)
                .tabItem {
                    Label {
                        Text("일정")
                            .pickText(type: .body3, textColor: .Normal.black)
                    } icon: {
                        PiCKImage.scheduleIcon
                    }
                }
            
            NavigationView {
                HomeView(store: store)
                    .navigationBarTitleDisplayMode(.inline)
            }
            .navigationViewStyle(.stack)
            .tag(2)
            .tabItem {
                Label {
                    Text("홈")
                        .pickText(type: .body3, textColor: .Normal.black)
                } icon: {
                    PiCKImage.homeIcon
                }
            }
            
            acceptFactory.makeView()
                .tag(3)
                .tabItem {
                    Label {
                        Text("수락")
                            .pickText(type: .body3, textColor: .Normal.black)
                    } icon: {
                        PiCKImage.applyIcon
                    }
                }
            
            allTabFactory.makeView()
                .tag(4)
                .tabItem {
                    Label {
                        Text("전체")
                            .pickText(type: .body3, textColor: .Normal.black)
                    } icon: {
                        PiCKImage.allTabIcon
                    }
                }
        }
        .tint(Color.Primary.primary500)
    }
}
