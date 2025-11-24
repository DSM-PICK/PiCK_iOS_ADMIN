import SwiftUI
import PiCK_iOS_DesignSystem

extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}

struct ClassroomSelectionBottomSheet: View {
    @Binding var isPresented: Bool
    @Binding var selectedGrade: Int
    @Binding var selectedClassNum: Int
    let onSelect: (Bool, Int, Int) -> Void

    var body: some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 100)
                .foregroundColor(.Gray.gray300)
                .frame(width: 40, height: 5)
                .padding(.top, 12)

            HStack {
                Text("교실 선택")
                    .pickText(type: .label1, textColor: .Normal.black)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)

            Spacer().frame(height: 20)

            PiCKButton(
                buttonText: "전체",
                isEnabled: true,
                height: 47
            ) {
                onSelect(true, 1, 1)
                isPresented = false
            }
            .padding(.horizontal, 24)

            Spacer().frame(height: 20)

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.Primary.primary50)
                    .frame(height: 32)
                    .padding(.horizontal, 24)

                HStack(spacing: 30) {
                    HStack(spacing: 0) {
                        Picker("", selection: $selectedGrade) {
                            ForEach(1...3, id: \.self) { num in
                                Text("\(num)")
                                    .pickText(type: .subTitle1, textColor: .Normal.black)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 50)
                        .clipped()
                        .compositingGroup()

                        Text("학년")
                            .pickText(type: .subTitle1, textColor: .Normal.black)
                            .offset(x: -15)
                    }

                    Text("-")
                        .pickText(type: .heading3, textColor: .Normal.black)

                    HStack(spacing: 0) {
                        Picker("", selection: $selectedClassNum) {
                            ForEach(1...4, id: \.self) { num in
                                Text("\(num)")
                                    .pickText(type: .subTitle1, textColor: .Normal.black)
                            }
                        }
                        .pickerStyle(.wheel)
                        .frame(width: 50)
                        .clipped()
                        .compositingGroup()

                        Text("반")
                            .pickText(type: .subTitle1, textColor: .Normal.black)
                            .offset(x: -15)
                    }
                }
                .onAppear { removePickerBackground() }
            }
            .frame(height: 150)

            Spacer().frame(height: 20)

            PiCKButton(
                buttonText: "선택 완료",
                isEnabled: true,
                height: 47
            ) {
                onSelect(false, selectedGrade, selectedClassNum)
                isPresented = false
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 28)
        }
    }

    private func removePickerBackground() {
        DispatchQueue.main.async {
            UIPickerView.appearance().backgroundColor = .clear

            guard let window = UIApplication.shared.connectedScenes
                .compactMap({ $0 as? UIWindowScene })
                .flatMap({ $0.windows })
                .first(where: { $0.isKeyWindow }) else { return }

            func clearBackground(in view: UIView) {
                if let pickerView = view as? UIPickerView {
                    pickerView.backgroundColor = .clear
                    pickerView.subviews.forEach { $0.backgroundColor = .clear }
                }
                view.subviews.forEach { clearBackground(in: $0) }
            }

            clearBackground(in: window)
        }
    }
}
