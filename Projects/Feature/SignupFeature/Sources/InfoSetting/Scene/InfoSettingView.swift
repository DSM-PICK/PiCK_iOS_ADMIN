import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility
import BaseFeature

struct InfoSettingView: View {
    let store: StoreOf<InfoSettingReducer>
    @EnvironmentObject var router: AppRouter
    @Environment(\.dismiss) var dismiss
    @State private var isSheetPresented = false
    @State private var tempGrade: Int = 0
    @State private var tempClass: Int = 0
    @State private var isTeacher = false

    public init(store: StoreOf<InfoSettingReducer>) {
        self.store = store
    }

    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            ZStack {
                BaseView {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: 0) {
                            Text("PiCK")
                                .foregroundColor(Color.Primary.primary500)
                            Text("에 회원가입하기")
                        }
                        .pickText(type: .heading2)
                        .padding(.top, 60)
                        .padding(.leading, 24)
                        
                        Text("선생님 정보를 입력해주세요.")
                            .pickText(type: .body1)
                            .padding(.leading, 24)
                            .padding(.top, 12)

                        HStack (spacing: 8){
                            Text("담임 선생님이신가요?")
                                .pickText(type: .subTitle1)
                            Button(action: {
                                isTeacher.toggle()
                            }, label: {
                                isTeacher ? PiCKImage.checkBoxOn : PiCKImage.checkBoxOff
                            })
                        }
                        .padding(.top, 48)
                        .padding(.leading, 24)

                        if isTeacher {
                            SchoolNumberSelectView(
                                selectedGrade: viewStore.binding(
                                    get: \.selectedGrade,
                                    send: InfoSettingReducer.Action.selectedGradeChanged
                                ),
                                selectedClass: viewStore.binding(
                                    get: \.selectedClass,
                                    send: InfoSettingReducer.Action.selectedClassChanged
                                ),
                                onTap: {
                                    tempGrade = viewStore.selectedGrade == 0 ? 1 : viewStore.selectedGrade
                                    tempClass = viewStore.selectedClass == 0 ? 1 : viewStore.selectedClass
                                    isSheetPresented = true
                                }
                            )
                            .padding(.horizontal, 24)
                            .padding(.top, 28)
                        }

                        PiCKTextField(
                            text: viewStore.binding(
                                get: \.name,
                                send: InfoSettingReducer.Action.nameChanged
                            ),
                            placeholder: "이름을 입력해주세요",
                            titleText: "이름"
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, 28)

                        Spacer()

                        PiCKButton(
                            buttonText: "완료",
                            isEnabled: {
                                if !viewStore.name.isEmpty {
                                    if isTeacher {
                                        return viewStore.selectedGrade != 0 && viewStore.selectedClass != 0
                                    } else {
                                        return true
                                    }
                                }
                                return false
                            }(),
                            action: { viewStore.send(.finishButtonTapped) }
                        )
                        .padding(.horizontal, 24)
                        .padding(.bottom, 28)
                    }
                }
                if isSheetPresented {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                isSheetPresented = false
                            }
                        
                        VStack {
                            Spacer()
                            
                            DualPickerBottomSheet.classroom(
                                isPresented: $isSheetPresented,
                                grade: $tempGrade,
                                klass: $tempClass
                            ) { selectedGrade, selectedKlass in
                                viewStore.send(.selectedGradeChanged(selectedGrade))
                                viewStore.send(.selectedClassChanged(selectedKlass))
                            }
                        }
                        .ignoresSafeArea()
                    }
                }
            }
            .onChange(of: viewStore.isSignupSuccessful) { isSuccessful in
                if isSuccessful {
                    router.path = [.home]
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(action: { router.pop() }) {
                        PiCKImage.leftArrow
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.Normal.black)
                    }
                }
            }
            .errorToast(
                message: viewStore.errorMessage ?? "에러발생!",
                isPresented: viewStore.binding(
                    get: { $0.errorMessage != nil },
                    send: .clearError
                )
            )
        }
    }
}
