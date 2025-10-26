import SwiftUI

public struct AllTabMenuList: View {
    public init() {}
    
    public var body: some View {
        MenuListView(
            sections: [
                MenuSectionModel(title: "출결 확인", items: [
                    MenuItemModel(icon: Image(systemName: "mappin.circle.fill"), title: "외출자 목록"),
                    MenuItemModel(icon: Image(systemName: "calendar.badge.clock"), title: "자습시간 출결"),
                    MenuItemModel(icon: Image(systemName: "books.vertical.fill"), title: "이전 외출기록")
                ]),
                MenuSectionModel(title: "도움말", items: [
                    MenuItemModel(icon: Image(systemName: "face.smiling.fill"), title: "자습 감독 선생님 확인"),
                    MenuItemModel(icon: Image(systemName: "ladybug.fill"), title: "버그 제보")
                ]),
                MenuSectionModel(title: "계정", items: [
                    MenuItemModel(icon: Image(systemName: "lock.rotation"), title: "비밀번호 변경")
                ])
            ]
        )
    }
}
