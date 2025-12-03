import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import AllTabDomainInterface
import HomeFeature
import Utility
import CheckSelfStudyTeacherFeature
import CheckSelfStudyTeacherDomainInterface

public struct AllTabView: View {
    let store: StoreOf<AllTabReducer>
    let fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol
    @EnvironmentObject var router: AppRouter
    @State private var navigationPath: [AppRoute] = []

    public init(
        store: StoreOf<AllTabReducer>,
        fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol
    ) {
        self.store = store
        self.fetchSelfStudyTeacherUseCase = fetchSelfStudyTeacherUseCase
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(path: $navigationPath) {
                ScrollView {
                    VStack(spacing: 0) {
                        TeacherInfoView(teacherName: viewStore.myName?.name)
                            .padding(.top, 24)
                        
                        AllTabMenuList(
                            onLogoutTap: {
                                viewStore.send(.logoutButtonTapped)
                            },
                            onCheckTeacherTap: {
                                navigationPath.append(.checkSelfStudyTeacher)
                            }
                        )
                        .padding(.top, 32)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    viewStore.send(.fetchMyName)
                }
                .onChange(of: viewStore.shouldLogout) { shouldLogout in
                    if shouldLogout {
                        router.path.removeAll()
                    }
                }
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .checkSelfStudyTeacher:
                        CheckSelfStudyTeacherFeature(
                            store: .init(
                                initialState: CheckSelfStudyTeacherReducer.State(),
                                reducer: {
                                    CheckSelfStudyTeacherReducer(
                                        fetchSelfStudyTeacherUseCase: fetchSelfStudyTeacherUseCase
                                    )
                                }
                            )
                        )
                    default:
                        EmptyView()
                    }
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
}
