import SwiftUI
import PiCK_iOS_DesignSystem
import HomeDomainInterface

public struct AllSelfStudyView: View {
    let selfStudyDirector: [SelfStudyDirectorEntity]

    public init(selfStudyDirector: [SelfStudyDirectorEntity]) {
        self.selfStudyDirector = selfStudyDirector
    }

    public var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0) {
                Text("오늘의 자습 감독 선생님 입니다")
                    .pickText(type: .label2)
                    .padding(.top, 27.5)
                    .padding(.leading, 20)
                
                VStack(alignment: .leading, spacing: 12) {
                    ForEach(selfStudyDirector, id: \.floor) { director in
                        FloorTeacherRow(
                            floor: "\(director.floor)층",
                            teacherName: director.teacherName
                        )
                    }
                }
                .padding(.top, 16)
                .padding(.leading, 20)
                
                Spacer()
            }
            .frame(maxWidth: .infinity, alignment: .topLeading)

            PiCKImage.calendar
                .resizable()
                .scaledToFit()
                .frame(width: 140, height: 140)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topTrailing)
                .padding(.top, 10)
                .padding(.trailing, 20)
                .padding(.bottom, 10)
                .allowsHitTesting(false)
        }
        .frame(maxWidth: .infinity, alignment: .topLeading)
        .background(Color.Gray.gray50)
        .cornerRadius(8)
    }
}

struct FloorTeacherRow: View {
    let floor: String
    let teacherName: String
    
    var body: some View {
        HStack(spacing: 16) {
            Text(floor)
                .pickText(type: .body2, textColor: Color.Primary.primary500)
            
            Text("\(teacherName) 선생님")
                .pickText(type: .subTitle3, textColor: Color.Normal.black)
        }
    }
}
