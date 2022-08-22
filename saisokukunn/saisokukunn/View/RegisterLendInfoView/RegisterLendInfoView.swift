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

    var body: some View {

        VStack {
            Spacer().frame(height: 100)

            TextField("タイトル", text: $title)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding()

            TextField("金額", text: $money)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.numberPad)
                .padding()

            DatePicker("日時を選択", selection: $endTime, displayedComponents: .date)
                .datePickerStyle(.compact)
                .labelsHidden()
                .padding()

            NavigationLink(
                destination: ConfirmLendInfoView(title: $title, money: $money, endTime: $endTime),
                isActive: $isActive,
                label: {
                    Button(action: {
                        if title.isEmpty && !money.isEmpty {
                            isActive = false
                            print("タイトルが入力されていない")
                        } else if !title.isEmpty && money.isEmpty {
                            isActive = false
                            print("金額が正しく入力されていない")
                        } else if title.isEmpty && money.isEmpty {
                            isActive = false
                            print("タイトルと金額が正しく入力されていない")
                        } else {
                            isActive = true
                        }
                    }) {
                        Text("確認ボタン")
                    }
                }
            )
        }
    }
}

//struct RegisterLendInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        RegisterLendInfoView()
//    }
//}
