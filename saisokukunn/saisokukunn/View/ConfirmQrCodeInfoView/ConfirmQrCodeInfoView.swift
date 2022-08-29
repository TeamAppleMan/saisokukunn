//
//  ConfirmQrCodeInfoView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI

struct ConfirmQrCodeInfoView: View {
    @State var title: String
    @State var lendPerson: String
    @State var money: String
    @State var endTime: Date

    var body: some View {
        Text("QRで読み取った情報の表示")
    }
}

//struct ConfirmQrCodeInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmQrCodeInfoView()
//    }
//}
