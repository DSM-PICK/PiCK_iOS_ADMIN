import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import AllTabDomainInterface
import HomeFeature
import Utility
import CheckSelfStudyTeacherFeature
import CheckSelfStudyTeacherDomainInterface
import BugReportFeature
import BugReportDomainInterface
import ChangePasswordFeature
import AuthDomainInterface
import ChangePasswordDomainInterface

public struct AllTabView: View {
    let store: StoreOf<AllTabReducer>
    let fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol
    let uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol
    let submitBugReportUseCase: any SubmitBugReportUseCaseProtocol
    let emailSendUseCase: any EmailSendUseCase
    let codeCheckUseCase: any CodeCheckUseCase
    let passwordChangeUseCase: any PasswordChangeUseCase
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
        passwordChangeUseCase: any PasswordChangeUseCase
    ) {
        self.store = store
        self.fetchSelfStudyTeacherUseCase = fetchSelfStudyTeacherUseCase
        self.uploadBugImagesUseCase = uploadBugImagesUseCase
        self.submitBugReportUseCase = submitBugReportUseCase
        self.emailSendUseCase = emailSendUseCase
        self.codeCheckUseCase = codeCheckUseCase
        self.passwordChangeUseCase = passwordChangeUseCase
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
                                router.path.append(.outList)
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
