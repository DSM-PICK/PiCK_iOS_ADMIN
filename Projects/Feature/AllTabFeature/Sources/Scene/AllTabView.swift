import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility
import AllTabDomainInterface
import AuthDomainInterface
import BugReportDomainInterface
import ChangePasswordDomainInterface
import CheckSelfStudyTeacherDomainInterface
import ClassroomMoveListDomainInterface
import ClassroomMoveListFeatureInterface
import OutListDomainInterface
import OutListFeatureInterface
import OutingHistoryDomainInterface
import OutingHistoryFeatureInterface
import SelfStudyCheckDomainInterface
import HomeFeature
import BugReportFeature
import ChangePasswordFeature
import CheckSelfStudyTeacherFeature
import ClassroomMoveListFeature
import OutListFeature
import OutingHistoryFeature
import SelfStudyCheckFeature

public struct AllTabView: View {
    let store: StoreOf<AllTabReducer>
    let fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol
    let uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol
    let submitBugReportUseCase: any SubmitBugReportUseCaseProtocol
    let emailSendUseCase: any EmailSendUseCase
    let codeCheckUseCase: any CodeCheckUseCase
    let passwordChangeUseCase: any PasswordChangeUseCase
    let getStudentAttendanceUseCase: any GetStudentAttendanceUseCase
    let saveAttendanceUseCase: any SaveAttendanceUseCase
    let getOutListUseCase: any GetOutListUseCase
    let returnStudentsUseCase: any ReturnStudentsUseCase
    let getEarlyReturnUseCase: any GetEarlyReturnUseCase
    let getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase
    let getClassroomMoveByClassroomUseCase: any GetClassroomMoveByClassroomUseCase
    let getOutingHistoryUseCase: GetOutingHistoryUseCase
    @EnvironmentObject var router: AppRouter
    @State private var navigationPath: [AppRoute] = []
    @State private var showPasswordChangeSuccess = false

    public init(
        store: StoreOf<AllTabReducer>,
        fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol,
        uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol,
        submitBugReportUseCase: any SubmitBugReportUseCaseProtocol,
        emailSendUseCase: any EmailSendUseCase,
        codeCheckUseCase: any CodeCheckUseCase,
        passwordChangeUseCase: any PasswordChangeUseCase,
        getStudentAttendanceUseCase: any GetStudentAttendanceUseCase,
        saveAttendanceUseCase: any SaveAttendanceUseCase,
        getOutListUseCase: any GetOutListUseCase,
        returnStudentsUseCase: any ReturnStudentsUseCase,
        getEarlyReturnUseCase: any GetEarlyReturnUseCase,
        getClassroomMoveByFloorUseCase: any GetClassroomMoveByFloorUseCase,
        getClassroomMoveByClassroomUseCase: any GetClassroomMoveByClassroomUseCase,
        getOutingHistoryUseCase: GetOutingHistoryUseCase
    ) {
        self.store = store
        self.fetchSelfStudyTeacherUseCase = fetchSelfStudyTeacherUseCase
        self.uploadBugImagesUseCase = uploadBugImagesUseCase
        self.submitBugReportUseCase = submitBugReportUseCase
        self.emailSendUseCase = emailSendUseCase
        self.codeCheckUseCase = codeCheckUseCase
        self.passwordChangeUseCase = passwordChangeUseCase
        self.getStudentAttendanceUseCase = getStudentAttendanceUseCase
        self.saveAttendanceUseCase = saveAttendanceUseCase
        self.getOutListUseCase = getOutListUseCase
        self.returnStudentsUseCase = returnStudentsUseCase
        self.getEarlyReturnUseCase = getEarlyReturnUseCase
        self.getClassroomMoveByFloorUseCase = getClassroomMoveByFloorUseCase
        self.getClassroomMoveByClassroomUseCase = getClassroomMoveByClassroomUseCase
        self.getOutingHistoryUseCase = getOutingHistoryUseCase
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStack(path: $navigationPath) {
                ScrollView {
                    VStack(spacing: 0) {
                        TeacherInfoView(teacherName: viewStore.myName?.name)
                            .padding(.top, 24)
                        

                        AllTabMenuList(
                            onOutListTap: {
                                navigationPath.append(.outList)
                            },
                            onClassroomMoveListTap: {
                                navigationPath.append(.classroomMoveList)
                            },
                            onLogoutTap: {
                                viewStore.send(.logoutButtonTapped)
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
                    case .bugReport:
                        BugReportFeature(
                            store: .init(
                                initialState: BugReportReducer.State(),
                                reducer: {
                                    BugReportReducer(
                                        uploadBugImagesUseCase: uploadBugImagesUseCase,
                                        submitBugReportUseCase: submitBugReportUseCase
                                    )
                                }
                            )
                        )
                    case .changePassword:
                        ChangePasswordFeature(
                            store: .init(
                                initialState: ChangePasswordReducer.State(),
                                reducer: {
                                    ChangePasswordReducer(
                                        emailSendUseCase: emailSendUseCase,
                                        codeCheckUseCase: codeCheckUseCase
                                    )
                                }
                            )
                        )
                    case .newPassword(let accountId, let code):
                        NewPasswordFeature(
                            store: .init(
                                initialState: NewPasswordReducer.State(),
                                reducer: {
                                    NewPasswordReducer(
                                        passwordChangeUseCase: passwordChangeUseCase,
                                        accountId: accountId,
                                        code: code
                                    )
                                }
                            ),
                            onSuccess: {
                                navigationPath.removeAll()
                                showPasswordChangeSuccess = true
                            }
                        )
                    case .selfStudyCheck:
                        SelfStudyCheckFeature(
                            store: .init(
                                initialState: SelfStudyCheckReducer.State(),
                                reducer: {
                                    SelfStudyCheckReducer(
                                        getStudentAttendanceUseCase: getStudentAttendanceUseCase,
                                        saveAttendanceUseCase: saveAttendanceUseCase
                                    )
                                }
                            )
                        )
                    case .outList:
                        OutListView(
                            store: .init(
                                initialState: OutListReducer.State(),
                                reducer: {
                                    OutListReducer(
                                        getOutListUseCase: getOutListUseCase,
                                        returnStudentsUseCase: returnStudentsUseCase,
                                        getEarlyReturnUseCase: getEarlyReturnUseCase
                                    )
                                }
                            )
                        )
                    case .classroomMoveList:
                        ClassroomMoveListView(
                            store: .init(
                                initialState: ClassroomMoveListReducer.State(),
                                reducer: {
                                    ClassroomMoveListReducer(
                                        getClassroomMoveByFloorUseCase: getClassroomMoveByFloorUseCase,
                                        getClassroomMoveByClassroomUseCase: getClassroomMoveByClassroomUseCase
                                    )
                                }
                            )
                        )
                    case .outingHistory:
                        OutingHistoryView(
                            store: .init(
                                initialState: OutingHistoryReducer.State(),
                                reducer: {
                                    OutingHistoryReducer(
                                        getOutingHistoryUseCase: getOutingHistoryUseCase
                                    )
                                }
                            )
                        )
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
