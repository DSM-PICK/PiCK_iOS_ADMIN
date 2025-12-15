import SwiftUI
import PiCK_iOS_DesignSystem

public struct AllTabMenuList: View {
    let onOutListTap: () -> Void
    let onClassroomMoveListTap: () -> Void
    let onLogoutTap: () -> Void
    let onCheckTeacherTap: () -> Void
    let onBugReportTap: () -> Void
    let onChangePasswordTap: () -> Void
    let onSelfStudyCheckTap: () -> Void
    let onOutingHistoryTap: () -> Void

    public init(
        onOutListTap: @escaping () -> Void,
        onClassroomMoveListTap: @escaping () -> Void,
        onLogoutTap: @escaping () -> Void,
        onCheckTeacherTap: @escaping () -> Void,
        onBugReportTap: @escaping () -> Void,
        onChangePasswordTap: @escaping () -> Void,
        onSelfStudyCheckTap: @escaping () -> Void,
        onOutingHistoryTap: @escaping () -> Void
    ) {
        self.onOutListTap = onOutListTap
        self.onClassroomMoveListTap = onClassroomMoveListTap
        self.onLogoutTap = onLogoutTap
        self.onCheckTeacherTap = onCheckTeacherTap
        self.onBugReportTap = onBugReportTap
        self.onChangePasswordTap = onChangePasswordTap
        self.onSelfStudyCheckTap = onSelfStudyCheckTap
        self.onOutingHistoryTap = onOutingHistoryTap
    }

    public var body: some View {
        MenuListView(
            sections: [
                MenuSectionModel(title: "출결 확인", items: [
                    MenuItemModel(
                        icon: PiCKImage.location,
                        title: "외출자 목록",
                        action: onOutListTap
                    ),
                    MenuItemModel(
                        icon: PiCKImage.beforeOuting,
                        title: "자습시간 출결",
                        action: onSelfStudyCheckTap
                    ),
                    MenuItemModel(icon: PiCKImage.book, title: "이전 외출기록")
                        icon: PiCKImage.classRoomMove, // admin classroomMove 아이콘 추가 필요
                        title: "교실 이동 현황",
                        action: onClassroomMoveListTap
                    ),
                    MenuItemModel(icon: PiCKImage.beforeOuting, title: "자습시간 출결"),
                    MenuItemModel(
                        icon: PiCKImage.book,
                        title: "이전 외출기록",
                        action: onOutingHistoryTap
                    )
                ]),
                MenuSectionModel(title: "도움말", items: [
                    MenuItemModel(
                        icon: PiCKImage.smile,
                        title: "자습 감독 선생님 확인",
                        action: onCheckTeacherTap
                    ),
                    MenuItemModel(
                        icon: PiCKImage.bug,
                        title: "버그 제보",
                        action: onBugReportTap
                    )
                ]),
                MenuSectionModel(title: "계정", items: [
                    MenuItemModel(
                        icon: PiCKImage.changePassword,
                        title: "비밀번호 변경",
                        action: onChangePasswordTap
                    ),
                    MenuItemModel(
                        icon: PiCKImage.logout,
                        title: "로그아웃",
                        iconColor: Color.Error.error,
                        action: onLogoutTap
                    )
                ])
            ]
        )
    }
}
