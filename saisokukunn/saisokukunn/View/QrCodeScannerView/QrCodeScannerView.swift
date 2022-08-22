//
//  QrCodeScannerView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI

struct QrCodeScannerView: View {
    var body: some View {
        VStack {
            Text("カメラをオンにして、")
                .font(.title)
            Text("Scan画面の実装")
                .font(.title)
            NavigationLink(destination: ConfirmQrCodeInfoView()) {
                Text("仮にスキャンできた").font(.callout)
            }
        }
    }
}

//struct QrCodeScannerView_Previews: PreviewProvider {
//    static var previews: some View {
//        QrCodeScannerView()
//    }
//}
