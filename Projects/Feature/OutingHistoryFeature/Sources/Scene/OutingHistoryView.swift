import Foundation
import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem

public struct OutingHistoryView: View {
    @Environment(\.dismiss) var dismiss
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
                            "이름 또는 학번으로 검색",
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
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 24)

                    Group {
                        if viewStore.isLoading {
                            VStack {
                                Spacer()
                                ProgressView()
                                Spacer()
                            }
                        } else if viewStore.filteredStudentItems.isEmpty {
                            VStack {
                                Spacer()
                                VStack(spacing: 12) {
                                    PiCKImage.blackLogo
                                        .resizable()
                                        .frame(width: 88, height: 91)

                                    Text("일치하는 학생이 없어요")
                                        .pickText(type: .subTitle2, textColor: .Gray.gray500)
                                }
                                Spacer()
                            }
                        } else {
                            ScrollView {
                                VStack {
                                    ForEach(viewStore.filteredStudentItems, id: \.id) { data in
                                        OutingHistoryCell(data: data)
                                    }
                                }
                            }
                        }
                    }
                }.onAppear {
                    viewStore.send(.onAppear)
                }
                .navigationTitle("이전 외출 기록")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarBackButtonHidden(true)
                .toolbar {
                    ToolbarItem(placement: .navigationBarLeading) {
                        Button {
                            dismiss()
                        } label: {
                            Image(systemName: "chevron.left")
                                .foregroundColor(.Gray.gray800)
                                .font(.system(size: 20))
                        }
                    }
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.endTextEditing()
            }
        }
    }
}

extension OutingHistoryView {
    func endTextEditing() {
        UIApplication.shared.sendAction(
            #selector(UIResponder.resignFirstResponder),
            to: nil,
            from: nil,
            for: nil
        )
    }
}
