import SwiftUI
import PiCK_iOS_DesignSystem
import HomeDomainInterface
import Utility

public struct SelfStudyView: View {
    public let selfStudyDirector: [SelfStudyDirectorEntity]

    public init(selfStudyDirector: [SelfStudyDirectorEntity]) {
        self.selfStudyDirector = selfStudyDirector
    }

    public var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(Date().toKoreanDateString())
                .pickText(type: .body3)
                .padding(.top, 14)
                .padding(.leading, 20)
            
            Spacer()
            
            if let director = selfStudyDirector.first {
                Text("\(director.teacherName) 선생님은 \(director.floor)층 자습감독 입니다")
                    .pickText(type: .body2, textColor: Color.Normal.black)
                    .padding(.bottom, 14)
                    .padding(.leading, 20)
            } else {
                Text("자습감독이 아닙니다")
                    .pickText(type: .body2, textColor: Color.Normal.black)
                    .padding(.bottom, 14)
                    .padding(.leading, 20)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        .background(Color.Gray.gray50)
        .cornerRadius(8)
    }
}
