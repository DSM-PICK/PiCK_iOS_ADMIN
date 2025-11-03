import SwiftUI
import PiCK_iOS_DesignSystem

public struct SchoolNumberSelectButton: View {
    let text: String
    let isSelected: Bool
    let action: () -> Void
    
    public init(
        text: String,
        isSelected: Bool = false,
        action: @escaping () -> Void
    ) {
        self.text = text
        self.isSelected = isSelected
        self.action = action
    }
    
    public var body: some View {
        Button(action: action) {
            Text(text)
                .pickText(type: .caption1, textColor: text == "선택" ? .Gray.gray500 : .Normal.black)
                .frame(width: 80, height: 43)
                .background(Color.Gray.gray50)
                .cornerRadius(8)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(isSelected ? Color.Primary.primary500 : Color.clear, lineWidth: 1)
                )
        }
    }
}

public struct SchoolNumberSelectView: View {
    @Binding var selectedGrade: Int?
    @Binding var selectedClass: Int?
    let onTap: () -> Void
    
    public init(
        selectedGrade: Binding<Int?>,
        selectedClass: Binding<Int?>,
        onTap: @escaping () -> Void
    ) {
        self._selectedGrade = selectedGrade
        self._selectedClass = selectedClass
        self.onTap = onTap
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("교실")
                .pickText(type: .label1, textColor: .Normal.black)
            HStack {
                SchoolNumberSelectButton(
                    text: (selectedGrade != nil) ? "\(selectedGrade!)" : "선택",
                    isSelected: selectedGrade != nil
                ) {
                    onTap()
                }
                Text("학년")
                    .pickText(type: .label1, textColor: .Normal.black)
                SchoolNumberSelectButton(
                    text: (selectedClass != nil) ? "\(selectedClass!)" : "선택",
                    isSelected: selectedClass != nil
                ) {
                    onTap()
                }
                Text("반")
                    .pickText(type: .label1, textColor: .Normal.black)
            }
        }
    }
}
