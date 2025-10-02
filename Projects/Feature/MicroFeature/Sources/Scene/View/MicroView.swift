import SwiftUI
import Store
import ViewUtil
import DesignSystem

struct MicroView: View {
    @StateObject var store: MicroStore

    var body: some View {
        VStack {
            Text(store.currentState.title)
                .font(.largeTitle)
            
            Spacer()
        }
        .onLoad {
            store.send(.viewDidLoad)
        }
        .navigationTitle("Micro Feature")
    }
}
