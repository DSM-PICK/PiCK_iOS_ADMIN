import SwiftUI
import PiCK_iOS_DesignSystem
import OutingHistoryDomainInterface

struct OutingHistoryCell: View {
    let data: OutingHistoryEntity
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("\(data.grade)\(data.classNum)\(String(format: "%02d", data.num)) \(data.userName)")
                .pickText(type: .subTitle1, textColor: .Normal.black)

            HStack(spacing: 12) {
                HStack(spacing: 8) {
                    Text("조기귀가")
                        .pickText(type: .label1, textColor: .Normal.white)
                        .frame(width: 68, height: 28)
                        .background(Color.Primary.primary300)
                        .cornerRadius(8)

                    Text("\(data.earlyReturnCnt)회")
                        .pickText(type: .caption1, textColor: .Normal.black)
                }

                HStack(spacing: 8) {
                    Text("외출")
                        .pickText(type: .label1, textColor: .Normal.white)
                        .frame(width: 64, height: 28)
                        .background(Color.Primary.primary500)
                        .cornerRadius(8)

                    Text("\(data.applicationCnt)회")
                        .pickText(type: .caption1, textColor: .Normal.black)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(16)
        .background(Color.Gray.gray50)
        .cornerRadius(8)
        .padding(.horizontal, 24)
        .padding(.bottom, 16)
    }
}
