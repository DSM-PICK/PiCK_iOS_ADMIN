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

public struct AllTabView: View {
    let store: StoreOf<AllTabReducer>
    let fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol
    let uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol
    let submitBugReportUseCase: any SubmitBugReportUseCaseProtocol
    let emailSendUseCase: any EmailSendUseCase
    let codeCheckUseCase: any CodeCheckUseCase
    @EnvironmentObject var router: AppRouter
    @State private var navigationPath: [AppRoute] = []

    public init(
        store: StoreOf<AllTabReducer>,
        fetchSelfStudyTeacherUseCase: any FetchSelfStudyTeacherUseCaseProtocol,
        uploadBugImagesUseCase: any UploadBugImagesUseCaseProtocol,
        submitBugReportUseCase: any SubmitBugReportUseCaseProtocol,
        emailSendUseCase: any EmailSendUseCase,
        codeCheckUseCase: any CodeCheckUseCase
    ) {
        self.store = store
        self.fetchSelfStudyTeacherUseCase = fetchSelfStudyTeacherUseCase
        self.uploadBugImagesUseCase = uploadBugImagesUseCase
        self.submitBugReportUseCase = submitBugReportUseCase
        self.emailSendUseCase = emailSendUseCase
        self.codeCheckUseCase = codeCheckUseCase
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
