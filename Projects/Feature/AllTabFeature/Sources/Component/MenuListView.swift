import SwiftUI
import PiCK_iOS_DesignSystem

public struct MenuListView: View {
    let sections: [MenuSectionModel]
    
    public init(sections: [MenuSectionModel]) {
        self.sections = sections
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            ForEach(sections) { section in
                MenuSectionView(section: section)
            }
        }
        .padding(.leading, 24)
    }
}

public struct MenuSectionModel: Identifiable {
    public let id = UUID()
    public let title: String
    public let items: [MenuItemModel]
    
    public init(title: String, items: [MenuItemModel]) {
        self.title = title
        self.items = items
    }
}

public struct MenuItemModel: Identifiable {
    public let id = UUID()
    public let icon: Image
    public let title: String
    public let action: (() -> Void)?
    
    public init(icon: Image, title: String, action: (() -> Void)? = nil) {
        self.icon = icon
        self.title = title
        self.action = action
    }
}

struct MenuSectionView: View {
    let section: MenuSectionModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(section.title)
                .pickText(type: .label1)
                .foregroundColor(Color.Gray.gray400)
                .padding(.top, 32)
                .padding(.bottom, 16)

            VStack(spacing: 0) {
                ForEach(section.items) { item in
                    MenuItemCell(item: item)
                }
            }
        }
    }
}

struct MenuItemCell: View {
    let item: MenuItemModel
    
    var body: some View {
        Button(action: {
            item.action?()
        }) {
            HStack(spacing: 20) {
                item.icon
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
                    .foregroundColor(Color.Primary.primary500)
                
                Text(item.title)
                    .pickText(type: .label1)
                    .foregroundColor(Color.Background.background)
                
                Spacer()
            }
            .padding(.vertical, 20)
            .background(Color.white)
            .contentShape(Rectangle())
        }
        .buttonStyle(PlainButtonStyle())
    }
}
