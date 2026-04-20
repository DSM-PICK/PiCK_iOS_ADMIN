import SwiftUI
import ComposableArchitecture
import PiCK_iOS_DesignSystem
import Utility
import BaseFeature

struct InfoSettingView: View {
    @Perception.Bindable var store: StoreOf<InfoSettingReducer>
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
        WithPerceptionTracking {
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

                        HStack(spacing: 8) {
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
                                selectedGrade: Binding(
                                    get: { store.selectedGrade == 0 ? nil : store.selectedGrade },
                                    set: { store.selectedGrade = $0 ?? 0 }
                                ),
                                selectedClass: Binding(
                                    get: { store.selectedClass == 0 ? nil : store.selectedClass },
                                    set: { store.selectedClass = $0 ?? 0 }
                                ),
                                onTap: {
                                    tempGrade = store.selectedGrade == 0 ? 1 : store.selectedGrade
                                    tempClass = store.selectedClass == 0 ? 1 : store.selectedClass
                                    isSheetPresented = true
                                }
                            )
                            .padding(.horizontal, 24)
                            .padding(.top, 28)
                        }

                        PiCKTextField(
                            text: $store.name,
                            placeholder: "이름을 입력해주세요",
                            titleText: "이름"
                        )
                        .padding(.horizontal, 24)
                        .padding(.top, 28)

                        Spacer()

                        PiCKButton(
                            buttonText: "완료",
                            isEnabled: {
                                if !store.name.isEmpty {
                                    if isTeacher {
                                        return store.selectedGrade != 0 && store.selectedClass != 0
                                    } else {
                                        return true
                                    }
                                }
                                return false
                            }(),
                            action: { store.send(.finishButtonTapped) }
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
                                store.selectedGrade = selectedGrade ?? 0
                                store.selectedClass = selectedKlass ?? 0
                            }
                        }
                        .ignoresSafeArea()
                    }
                }
            }
            .onChange(of: store.isSignupSuccessful) { isSuccessful in
                if isSuccessful {
                    router.path = [.home]
                }
            }
            .navigationBarBackButtonHidden(true)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button(
                        action: { router.pop() },
                        label: {
                        PiCKImage.leftArrow
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(.Normal.black)
                        }
                    )
                }
            }
            .errorToast(
                message: store.errorMessage ?? "에러발생!",
                isPresented: Binding(
                    get: { store.errorMessage != nil },
                    set: { isPresented in
                        if !isPresented {
                            store.send(.clearError)
                        }
                    }
                )
            )
        }
    }
}
