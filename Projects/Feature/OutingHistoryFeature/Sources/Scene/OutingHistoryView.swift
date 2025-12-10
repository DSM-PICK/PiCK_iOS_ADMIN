import Foundation
import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct OutingHistoryView: View {
    let store: StoreOf<OutingHistoryReducer>

    public init(store: StoreOf<OutingHistoryReducer>) {
        self.store = store
    }

    public var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                VStack(spacing: 0) {
                    HStack(spacing: 4) {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.Normal.black)
                            .padding(.leading, 16)

                        TextField(
                            "학생 이름으로 검색",
                            text: viewStore.binding(
                                get: \.searchText,
                                send: OutingHistoryReducer.Action.searchTextChanged
                            )
                        )
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal, 16)
                        .padding(.vertical, 10)
                    }
                    .background(Color.Gray.gray50)
                    .cornerRadius(8)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 24)

                    ScrollView {
                        VStack {
                            ForEach(viewStore.filteredStudentItems, id: \.id) { data in
                                OutingHistoryCell(data: data)
                            }
                        }
                    }
                }.onAppear {
                    viewStore.send(.onAppear)
                }
                .navigationTitle("이전 외출 기록")
                .navigationBarTitleDisplayMode(.inline)
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.endTextEdting()
            }
        }
    }
}

extension OutingHistoryView {
    func endTextEdting() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
