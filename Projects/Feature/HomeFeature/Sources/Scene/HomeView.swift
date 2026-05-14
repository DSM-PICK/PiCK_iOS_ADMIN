import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import HomeDomainInterface
import Utility

public struct HomeView: View {
    @Perception.Bindable var store: StoreOf<HomeReducer>

    public init(store: StoreOf<HomeReducer>) {
        self.store = store
    }

    public var body: some View {
        WithPerceptionTracking {
            ZStack {
                ScrollView {
                    VStack(spacing: 24) {
                        SelfStudyView(
                            adminMessage: store.adminSelfStudyTeacher
                        )
                        .frame(maxWidth: .infinity)
                        .frame(height: 72)

                        if store.isHomeroomTeacher {
                            AccordionView(
                                badge: store.classroom,
                                title: "외출 수락",
                                content: {
                                    VStack(spacing: 8) {
                                        if store.outingAcceptList.isEmpty {
                                            emptyStateView(message: "외출 신청이 없습니다")
                                        } else {
                                            ForEach(store.outingAcceptList) { item in
                                                AcceptCell(
                                                    studentNumber: self.studentNumber(
                                                        grade: item.grade,
                                                        classNum: item.classNum,
                                                        num: item.num
                                                    ),
                                                    name: item.userName,
                                                    type: item.type,
                                                    onAccept: {
                                                        switch item.type {
                                                        case .outgoing:
                                                            store.send(.acceptApplication(id: item.id))
                                                        case .earlyReturn:
                                                            store.send(.acceptEarlyReturn(id: item.id))
                                                        }
                                                    },
                                                    onReject: {
                                                        switch item.type {
                                                        case .outgoing:
                                                            store.send(.rejectApplication(id: item.id))
                                                        case .earlyReturn:
                                                            store.send(.rejectEarlyReturn(id: item.id))
                                                        }
                                                    }
                                                )
                                            }
                                        }
                                    }
                                    .padding(.vertical, 12)
                                }
                            )
                        }

                        if store.isSelfStudyTeacher {
                            AccordionView(
                                badge: store.floor,
                                title: "외출자 확인",
                                content: {
                                    VStack(spacing: 8) {
                                        if store.outingStudentList.isEmpty {
                                            emptyStateView(message: "외출자가 없습니다")
                                        } else {
                                            ForEach(store.outingStudentList) { item in
                                                OutingCell(
                                                    studentNumber: self.studentNumber(
                                                        grade: item.grade,
                                                        classNum: item.classNum,
                                                        num: item.num
                                                    ),
                                                    name: item.userName,
                                                    type: item.type
                                                )
                                            }
                                        }
                                    }
                                    .padding(.vertical, 12)
                                }
                            )

                            AccordionView(
                                badge: store.floor,
                                title: "교실 이동자 확인",
                                content: {
                                    VStack(spacing: 8) {
                                        if store.classroomMoveList.isEmpty {
                                            emptyStateView(message: "교실 이동자가 없습니다")
                                        } else {
                                            ForEach(store.classroomMoveList, id: \.id) { item in
                                                PiCKClassroomMoveCell(
                                                    studentNumber: self.studentNumber(
                                                        grade: item.grade,
                                                        classNum: item.classNum,
                                                        num: item.num
                                                    ),
                                                    studentName: item.userName,
                                                    startPeriod: item.start,
                                                    endPeriod: item.end,
                                                    currentClassroom: "\(item.grade)학년 \(item.classNum)반",
                                                    moveToClassroom: item.classroomName,
                                                    isSelected: false,
                                                    onTap: {}
                                                )
                                            }
                                        }
                                    }
                                    .padding(.vertical, 12)
                                }
                            )
                        }

                        AllSelfStudyView(selfStudyDirector: store.selfStudyDirector)
                            .frame(maxWidth: .infinity)
                    }
                    .padding(24)
                }
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        PiCKNavigationBar()
                            .padding(.leading, 8)
                    }
                }
                .onAppear {
                    store.send(.fetchSelfStudyDirector(date: Date.todayString()))
                    store.send(.fetchAdminSelfStudyInfo)
                    store.send(.fetchSelfStudyAndClassroom)
                }
                if store.showAlert {
                    PiCKDisappearAlert(
                        successType: store.alertSuccessType,
                        message: store.alertMessage
                    )
                    .onDisappear {
                        store.send(.dismissAlert)
                    }
                }
            }
        }
    }
}

extension HomeView {
    private func studentNumber(grade: Int, classNum: Int, num: Int) -> String {
        return "\(grade)\(classNum)\(num < 10 ? "0" : "")\(num)"
    }

    private func emptyStateView(message: String) -> some View {
        Text(message)
            .pickText(type: .body1, textColor: .Gray.gray600)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 24)
    }
}
