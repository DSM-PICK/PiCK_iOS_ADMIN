import SwiftUI
import PiCK_iOS_DesignSystem

public struct TeacherInfoView: View {
    let teacherName: String?
    
    public init(teacherName: String?) {
        self.teacherName = teacherName
    }
    
    public var body: some View {
        HStack(spacing: 0) {
            PiCKImage.profile
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .padding(.leading, 24)
                .padding(.top, 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("대덕소프트웨어마이스터고등학교")
                    .pickText(type: .label1, textColor: Color.Normal.black)
                
                Text("\(teacherName ?? "") 선생님")
                    .pickText(type: .label1, textColor: Color.Normal.black)
            }
            .padding(.leading, 24)
            .padding(.top, 12)
            
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .frame(height: 84)
        .background(Color.white)
    }
}
