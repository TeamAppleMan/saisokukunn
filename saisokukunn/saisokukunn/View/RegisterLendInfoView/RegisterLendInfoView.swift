//
//  RegisterLendInfoView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI

struct RegisterLendInfoView: View {
    @State var title: String = ""
    @State var money: String = ""
    @State var endTime: Date = Date()
    @State var isNextButtonActive: Bool = false
    @State var aleartText: String = ""

    var body: some View {
        let displayBounds = UIScreen.main.bounds
        let displayHeight = displayBounds.height
        // 各々のサイズ指定
        let textHorizontalMargin = 25.0
        let inputAccessoryHorizontalMargin = 25.0
        let imageHeight = displayHeight/3.25
        let confirmationButtonWidth = 150.0
        let thinGrayColor = Color.init(red: 0.92, green: 0.92, blue: 0.92)

        let titleTextColor = Color.init(red: 0.3, green: 0.3, blue: 0.3)

        VStack() {

            Spacer()

            HStack() {
                Image("MoneyWithMan")
                    .resizable()
                    .scaledToFit()
                    .frame(height: imageHeight, alignment: .center)
            }.padding(.bottom)

            VStack(alignment: .leading, spacing: 5) {
                Text("タイトル")
                    .font(.callout)
                    .foregroundColor(titleTextColor)
                    .padding(.leading, textHorizontalMargin)
                TextField("お金を借りるタイトル", text: $title)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding([.leading, .bottom, .trailing], inputAccessoryHorizontalMargin)

                Text("金額")
                    .font(.callout)
                    .foregroundColor(titleTextColor)
                    .padding(.leading, textHorizontalMargin)
                TextField("借りる金額", text: $money)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .keyboardType(.numberPad)
                    .padding([.leading, .bottom, .trailing], inputAccessoryHorizontalMargin)

                Text("締め切り")
                    .font(.callout)
                    .foregroundColor(titleTextColor)
                    .padding(.leading, textHorizontalMargin)
                DatePicker("日時を選択", selection: $endTime, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .labelsHidden()
                    .padding([.leading, .trailing], inputAccessoryHorizontalMargin)

                HStack {
                    Spacer()
                    NavigationLink(
                        destination: ConfirmLendInfoView(title: $title, money: $money, endTime: $endTime, createdQrImage: Image("")),
                        isActive: $isNextButtonActive,
                        label: {
                            Button(action: {
                                isNextButtonActive = true
                            }) {
                                Text("確認")
                                    .frame(width: confirmationButtonWidth, alignment: .center)
                                    .padding()
                                    .accentColor(title.isEmpty || money.isEmpty ? Color.gray : Color.white)
                                    .background(title.isEmpty || money.isEmpty ? thinGrayColor : Color.gray)
                                    .cornerRadius(25)
                                    .shadow(color: title.isEmpty || money.isEmpty ? Color.white : Color.gray, radius: 10, x: 0, y: 3)
                                    .padding()
                            }
                            .disabled(title.isEmpty || money.isEmpty)
                        }
                    )
                    Spacer()
                }
            }
            Spacer()
        }
        // キーボードを画面タッチで閉じさせる
        .edgesIgnoringSafeArea(.all)
        .onTapGesture { UIApplication.shared.closeKeyboard() }
    }
}

//struct RegisterLendInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        NavigationView{
//            RegisterLendInfoView()
//        }
//    }
//}
