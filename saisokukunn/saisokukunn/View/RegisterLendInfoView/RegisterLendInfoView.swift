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
    @State var isActive: Bool = false
    @State var aleartText: String = ""
    @State private var isShowAlert = false

    var body: some View {

        VStack(alignment: .leading, spacing: 5) {
            Text("タイトル")
                .padding(.leading)
            TextField("お金を貸すタイトル", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding([.leading, .bottom, .trailing])

            Text("金額")
                .padding(.leading)
            TextField("貸す金額", text: $money)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding([.leading, .bottom, .trailing])

            Text("締め切り")
                .padding(.leading)
            DatePicker("日時を選択", selection: $endTime, displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .padding([.leading, .bottom, .trailing])

            NavigationLink(
                destination: ConfirmLendInfoView(title: $title, money: $money, endTime: $endTime),
                isActive: $isActive,
                label: {
                    Button(action: {
                        if title.isEmpty && !money.isEmpty {
                            isActive = false
                            isShowAlert = true
                            aleartText = "タイトルを入力して下さい"
                        } else if !title.isEmpty && money.isEmpty {
                            isActive = false
                            isShowAlert = true
                            aleartText = "金額を入力して下さい"
                        } else if title.isEmpty && money.isEmpty {
                            isActive = false
                            isShowAlert = true
                            aleartText = "タイトルと金額を入力して下さい"
                        } else {
                            isActive = true
                        }
                    }) {
                        Text("確認ボタン")
                    }
                    .alert(isPresented: $isShowAlert) {  // ③アラートの表示条件設定
                        Alert(title: Text("エラー"), message: Text(aleartText))
                    }
                }
            )
        }
    }
}

struct RegisterLendInfoView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterLendInfoView()
    }
}
