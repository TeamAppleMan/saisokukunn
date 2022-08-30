//
//  QrCodeBoxView.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/08/29.
//

import SwiftUI

struct QrCodeBoxView: View {
    let qrImage: Image
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 10)

            qrImage
                .resizable()
                .scaledToFit()
                .padding()

        }
    }
}

//struct QrCodeBoxView_Previews: PreviewProvider {
//    static var previews: some View {
//        QrCodeBoxView(qrImage: )
//    }
//}
