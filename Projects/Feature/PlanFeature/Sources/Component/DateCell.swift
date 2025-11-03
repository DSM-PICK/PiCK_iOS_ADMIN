import SwiftUI
import PiCK_iOS_DesignSystem

struct DateCell: View {
    let date: Date
    let isSelected: Bool
    let isToday: Bool
    let hasEvent: Bool
    let isCurrentMonth: Bool
    
    private let calendar = Calendar.current
    
    var body: some View {
        VStack(spacing: 4) {
            Text("\(calendar.component(.day, from: date))")
                .font(.system(size: 14, weight: isSelected ? .semibold : .regular))
                .foregroundColor(textColor)
                .frame(width: 36, height: 36)
                .background(backgroundColor)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(borderColor, lineWidth: isSelected && !isToday ? 2 : 0)
                )
            
            if hasEvent {
                Circle()
                    .fill(Color.Primary.primary500)
                    .frame(width: 4, height: 4)
            } else {
                Color.clear
                    .frame(width: 4, height: 4)
            }
        }
        .opacity(isCurrentMonth ? 1.0 : 0.3)
    }
    
    private var textColor: Color {
        if !isCurrentMonth {
            return .gray
        }
        if isSelected || isToday {
            return .black
        }
        return .black
    }
    
    private var backgroundColor: Color {
        if isToday {
            return Color.Primary.primary100
        }
        return .clear
    }
    
    private var borderColor: Color {
        if isSelected && !isToday {
            return Color.Primary.primary100
        }
        return .clear
    }
}
