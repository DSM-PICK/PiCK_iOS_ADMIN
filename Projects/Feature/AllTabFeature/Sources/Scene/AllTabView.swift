import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility
import AllTabDomainInterface
import BugReportFeatureInterface
import CheckSelfStudyTeacherFeatureInterface
import ChangePasswordFeatureInterface
import ClassroomMoveListFeatureInterface
import OutListFeatureInterface
import OutingHistoryFeatureInterface
import SelfStudyCheckFeatureInterface

public struct AllTabView: View {
    @Perception.Bindable var store: StoreOf<AllTabReducer>
    let checkSelfStudyTeacherFactory: any CheckSelfStudyTeacherFactory
    let bugReportFactory: any BugReportFactory
    let changePasswordFactory: any ChangePasswordFactory
    let newPasswordFactory: any NewPasswordFactory
    let selfStudyCheckFactory: any SelfStudyCheckFactory
    let outListFactory: any OutListFactory
    let classroomMoveListFactory: any ClassroomMoveListFactory
    let outingHistoryFactory: any OutingHistoryFactory
    @EnvironmentObject var router: AppRouter
    @State private var navigationPath: [AppRoute] = []
    @State private var showPasswordChangeSuccess = false
    @State private var showResignAlert = false
    @State private var showLogoutConfirm = false

    public init(
        store: StoreOf<AllTabReducer>,
        checkSelfStudyTeacherFactory: any CheckSelfStudyTeacherFactory,
        bugReportFactory: any BugReportFactory,
        changePasswordFactory: any ChangePasswordFactory,
        newPasswordFactory: any NewPasswordFactory,
        selfStudyCheckFactory: any SelfStudyCheckFactory,
        outListFactory: any OutListFactory,
        classroomMoveListFactory: any ClassroomMoveListFactory,
        outingHistoryFactory: any OutingHistoryFactory
    ) {
        self.store = store
        self.checkSelfStudyTeacherFactory = checkSelfStudyTeacherFactory
        self.bugReportFactory = bugReportFactory
        self.changePasswordFactory = changePasswordFactory
        self.newPasswordFactory = newPasswordFactory
        self.selfStudyCheckFactory = selfStudyCheckFactory
        self.outListFactory = outListFactory
        self.classroomMoveListFactory = classroomMoveListFactory
        self.outingHistoryFactory = outingHistoryFactory
    }

    public var body: some View {
        WithPerceptionTracking {
            NavigationStack(path: $navigationPath) {
                ScrollView {
                    VStack(spacing: 0) {
                        TeacherInfoView(teacherName: store.myName?.name)
                            .padding(.top, 24)

                        AllTabMenuList(
                            onOutListTap: {
                                navigationPath.append(.outList)
                            },
                            onClassroomMoveListTap: {
                                navigationPath.append(.classroomMoveList)
                            },
                            onLogoutTap: {
                                showLogoutConfirm = true
                            },
                            onCheckTeacherTap: {
                                navigationPath.append(.checkSelfStudyTeacher)
                            },
                            onBugReportTap: {
                                navigationPath.append(.bugReport)
                            },
                            onChangePasswordTap: {
                                navigationPath.append(.changePassword)
                            },
                            onSelfStudyCheckTap: {
                                navigationPath.append(.selfStudyCheck)
                            },
                            onOutingHistoryTap: {
                                navigationPath.append(.outingHistory)
                            },
                            onResignTap: {
                                showResignAlert = true
                            }
                        )
                        .padding(.top, 32)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .onAppear {
                    store.send(.fetchMyName)
                }
                .onChange(of: store.shouldLogout) { shouldLogout in
                    if shouldLogout {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                router.path.removeAll()
                            }
                        }
                    }
                }
                .onChange(of: store.shouldResign) { shouldResign in
                    if shouldResign {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                router.path.removeAll()
                            }
                        }
                    }
                }
                .confirmPopUp(
                    title: "로그아웃",
                    explain: "정말 로그아웃 하시겠습니까?",
                    type: .reject,
                    isPresented: $showLogoutConfirm,
                    onAction: { action in
                        if action == .accept {
                            store.send(.logoutButtonTapped)
                        }
                    }
                )
                .confirmPopUp(
                    title: "회원탈퇴",
                    explain: "정말로 탈퇴하시겠습니까?\n탈퇴 후에는 계정을 복구할 수 없습니다.",
                    type: .reject,
                    isPresented: $showResignAlert,
                    onAction: { action in
                        if action == .accept {
                            store.send(.confirmResign)
                        }
                    }
                )
                .navigationDestination(for: AppRoute.self) { route in
                    switch route {
                    case .checkSelfStudyTeacher:
                        checkSelfStudyTeacherFactory.makeView()
                    case .bugReport:
                        bugReportFactory.makeView()
                    case .changePassword:
                        changePasswordFactory.makeView()
                    case .newPassword(let accountId, let code):
                        newPasswordFactory.makeView(
                            accountId: accountId,
                            code: code,
                            onSuccess: {
                                navigationPath.removeAll()
                                showPasswordChangeSuccess = true
                            }
                        )
                    case .selfStudyCheck:
                        selfStudyCheckFactory.makeView()
                    case .outList:
                        outListFactory.makeView()
                    case .classroomMoveList:
                        classroomMoveListFactory.makeView()
                    case .outingHistory:
                        outingHistoryFactory.makeView()
                    default:
                        EmptyView()
                    }
                }
                .alert("비밀번호 변경 완료", isPresented: $showPasswordChangeSuccess) {
                    Button("확인", role: .cancel) { }
                } message: {
                    Text("비밀번호가 성공적으로 변경되었습니다.")
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
