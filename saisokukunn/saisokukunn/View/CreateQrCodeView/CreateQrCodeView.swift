//
//  CreateQrCodeView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI

struct CreateQrCodeView: View {
    // ConfirmQrCodeViewから受け取るQrのimage
    let qrImage: Image
    @EnvironmentObject var environmentData: EnvironmentData
    // ConfirmQrCodeViewから受け取るドキュメントPath
    @State var documentPath: String

    let loadPayTask = LoadPayTask()

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

            // ConfirmLendInfoViewで作成されたqr写真を表示
            QrCodeBoxView(qrImage: qrImage)
                .frame(width: squareQrcodeBoxSize, height: squareQrcodeBoxSize)
                .padding(.top, 40)

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
        .onAppear {
            print("相手がQRスキャンしたか、通信中")
            print("documentPath:",documentPath)
            // Firestoreから借りているPayTaskの情報を取得する
            loadPayTask.fetchLinkPayTask(documentPath: documentPath, completion: { borrowPayTasks, error in
                if let error = error {
                    print("borrowPayTasksの取得に失敗",error)
                }

                if let _ = borrowPayTasks?.lenderUID, let _ = borrowPayTasks?.lenderUserName {
                    environmentData.isBorrowViewActiveEnvironment.wrappedValue = false
                }
            })

        }
        .onDisappear {
            // 画面がMainへ直接遷移した際にPKHUDの出力。
            if !environmentData.isBorrowViewActiveEnvironment.wrappedValue {
                environmentData.isAddDataPkhudAlert = true
            }
        }

    }

}
