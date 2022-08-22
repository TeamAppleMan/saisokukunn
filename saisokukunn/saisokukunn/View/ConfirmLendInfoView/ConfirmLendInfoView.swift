//
//  ConfirmLendInfoView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI

struct ConfirmLendInfoView: View {
    @Binding var title: String
    @Binding var money: String
    @Binding var endTime: Date

    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: endTime)
    }

    var body: some View {
        VStack{
            HStack {
                Text("タイトル")
                    .padding()
                Text(title)
            }

            HStack {
                Text("金額")
                    .padding()
                Text("¥\(money)")
            }

            HStack {
                Text("締め切り")
                    .padding()
                Text(dateToString(date: endTime))
            }

            NavigationLink(destination: CreateQrCodeView()) {
                Text("OK").font(.callout)
            }
            .padding()

        }
    }
}

//struct ConfirmLendInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmLendInfoView()
//    }
//}
