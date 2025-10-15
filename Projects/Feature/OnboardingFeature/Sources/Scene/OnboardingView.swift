import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility

struct OnboardingView: View {
    let store: StoreOf<OnboardingReducer>
    @EnvironmentObject var router: AppRouter
    
    public init(store: StoreOf<OnboardingReducer>) {
        self.store = store
    }
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                Text("Onboarding")
                    .pickText(type: .heading2)
                
                Spacer()
                
                PiCKButton(
                    buttonText: "Next",
                    action: { router.path.append(.home) }
                )
                .padding(.horizontal, 24)
                .padding(.bottom, 28)
            }
        }
    }
}
