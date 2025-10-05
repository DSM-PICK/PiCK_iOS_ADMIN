import SwiftUI

struct AuthView: View {
    @StateObject var viewModel: AuthViewModel

    public init(viewModel: AuthViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        Text("Hello, Auth!")
    }
}