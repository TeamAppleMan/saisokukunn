//
//  CreateQrCodeView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI

struct CreateQrCodeView: View {

    var body: some View {
        let displayBounds = UIScreen.main.bounds
        let displayWidth = displayBounds.width
        let displayHeight = displayBounds.height
        let textColor = Color.init(red: 0.3, green: 0.3, blue: 0.3)

        // 画像の高さ
        let imageHeight = displayHeight/2.0
        // QRコードボックスのサイズ
        let squareQrcodeBoxSize = displayWidth - 120.0
        // QRボックスと画像を重ねるためにずらすoffsetサイズ
        let packOffsetSize = 3*imageHeight/12

        VStack(spacing: 0) {

            QrCodeBoxView()
                .frame(width: squareQrcodeBoxSize, height: squareQrcodeBoxSize)
                .padding()

            Image("SendDateWithMan")
                .resizable()
                .scaledToFit()
                .frame(height: imageHeight, alignment: .center)
                .offset(x: 0, y: -packOffsetSize)

            Text("相手側のアプリでスキャンして下さい。")
                .foregroundColor(textColor)
                .font(.callout)
                .offset(x: 0, y: -packOffsetSize)
            Text("スキャン後自動で画面は戻ります。")
                .foregroundColor(textColor)
                .font(.callout)
                .offset(x: 0, y: -packOffsetSize)
            Spacer()
        }

    }

}

//struct CreateQrCodeView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateQrCodeView(title: Binding("お好み焼き代"), money: Binding(4850), endTime: Binding(Date()))
//    }
//}
