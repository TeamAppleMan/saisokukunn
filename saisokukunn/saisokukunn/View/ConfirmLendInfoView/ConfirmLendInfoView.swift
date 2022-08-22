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
            Text(title)
            Text(money)

            Text(dateToString(date: endTime))

            NavigationLink(destination: CreateQrCodeView()) {
                Text("OK").font(.callout)
            }
        }
    }
}

//struct ConfirmLendInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmLendInfoView()
//    }
//}
