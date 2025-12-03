import SwiftUI
import PiCK_iOS_DesignSystem

public struct AllTabMenuList: View {
    let onLogoutTap: () -> Void
    let onCheckTeacherTap: () -> Void

    public init(
        onLogoutTap: @escaping () -> Void,
        onCheckTeacherTap: @escaping () -> Void
    ) {
        self.onLogoutTap = onLogoutTap
        self.onCheckTeacherTap = onCheckTeacherTap
    }

    public var body: some View {
        MenuListView(
            sections: [
                MenuSectionModel(title: "출결 확인", items: [
                    MenuItemModel(icon: PiCKImage.location, title: "외출자 목록"),
                    MenuItemModel(icon: PiCKImage.beforeOuting, title: "자습시간 출결"),
                    MenuItemModel(icon: PiCKImage.book, title: "이전 외출기록")
                ]),
                MenuSectionModel(title: "도움말", items: [
                    MenuItemModel(
                        icon: PiCKImage.smile,
                        title: "자습 감독 선생님 확인",
                        action: onCheckTeacherTap
                    ),
                    MenuItemModel(icon: PiCKImage.bug, title: "버그 제보")
                ]),
                MenuSectionModel(title: "계정", items: [
                    MenuItemModel(icon: PiCKImage.changePassword, title: "비밀번호 변경"),
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
