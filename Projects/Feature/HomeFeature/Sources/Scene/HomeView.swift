import SwiftUI
import PiCK_iOS_DesignSystem
import ComposableArchitecture
import HomeDomainInterface
import AcceptDomainInterface
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

                    if viewStore.isHomeroomTeacher {
                        AccordionView(
                            badge: viewStore.classroom,
                            title: "외출 수락",
                            content: {
                                VStack(spacing: 8) {
                                    if viewStore.acceptList.isEmpty {
                                        Text("외출 신청이 없습니다")
                                            .pickText(type: .body1, textColor: .Gray.gray600)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 24)
                                    } else {
                                        ForEach(viewStore.acceptList) { item in
                                            AcceptCell(
                                                studentNumber: self.studentNumber(grade: item.grade, classNum: item.grade, num: item.num),
                                                name: item.userName,
                                                type: .outgoing,
                                                onAccept: {
                                                    viewStore.send(.acceptApplication(id: item.id))
                                                },
                                                onReject: {
                                                    viewStore.send(.rejectApplication(id: item.id))
                                                }
                                            )
                                        }
                                    }
                                }
                                .padding(.vertical, 12)
                            }
                        )
                    }

                    if viewStore.isSelfStudyTeacher {
                        AccordionView(
                            badge: viewStore.floor,
                            title: "외출자 확인",
                            content: {
                                VStack(spacing: 8) {
                                    if viewStore.outingStudentList.isEmpty {
                                        Text("외출자가 없습니다")
                                            .pickText(type: .body1, textColor: .Gray.gray600)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 24)
                                    } else {
                                        ForEach(viewStore.outingStudentList) { item in
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
                            badge: viewStore.floor,
                            title: "교실 이동자 확인",
                            content: {
                                VStack(spacing: 8) {
                                    if viewStore.classroomMoveList.isEmpty {
                                        Text("교실 이동자가 없습니다")
                                            .pickText(type: .body1, textColor: .Gray.gray600)
                                            .frame(maxWidth: .infinity)
                                            .padding(.vertical, 24)
                                    } else {
                                        ForEach(viewStore.classroomMoveList, id: \.id) { item in
                                            PiCKClassroomMoveCell(
                                                studentNumber: self.studentNumber(grade: item.grade, classNum: item.grade, num: item.num),
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

                    AllSelfStudyView(selfStudyDirector: viewStore.selfStudyDirector)
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
                viewStore.send(.fetchSelfStudyDirector(date: Date.todayString()))
                viewStore.send(.fetchAdminSelfStudyInfo)
                viewStore.send(.fetchSelfStudyAndClassroom)
            }
        }
    }
}

extension HomeView {
    private func studentNumber(grade: Int, classNum: Int, num: Int) -> String {
        return "\(grade)\(classNum)\(num < 10 ? "0" : "")\(num)"
    }
}
