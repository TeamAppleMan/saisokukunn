//
//  ConfirmLendInfoView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//


import SwiftUI

struct ConfirmLendInfoView: View {
    @ObservedObject var confirmLendInfoViewModel = ConfirmLendInfoViewModel()

    @Binding var title: String
    @Binding var money: String
    @Binding var endTime: Date
    @State private var toCreateQrCodeView = false
    @State private var isPkhudProgress = false
    @State private var isPkhudFailure = false
    @State var createdQrImage: Image
    @State var documentPath: String = ""
    var userName = String()

    // TODO: 下の関数は改良してModelに突っ込みたい
    func dateToString(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ja_JP")
        dateFormatter.dateStyle = .medium
        dateFormatter.dateFormat = "yyyy-MM-dd"
        return dateFormatter.string(from: endTime)
    }

    var body: some View {
        let displayBounds = UIScreen.main.bounds
        let displayWidth = displayBounds.width
        let displayHeight = displayBounds.height

        let imageHeight = displayHeight/3.0
        let squareTextBoxSize = displayWidth - 80.0
        let offsetSize = imageHeight/5
        let qrcodeButtonOffsetXSize = displayWidth/2 - 60.0
        let qrcodeButtonOffsetYSize = -60.0
        let qrcodeButtonShadowColor = Color.init(red: 0.4, green: 0.4, blue: 0.4)

        VStack {

            // CreateQrCodeに遷移する時にqrの画像を渡す
            NavigationLink(destination: CreateQrCodeView(qrImage: createdQrImage, documentPath: documentPath),isActive: $toCreateQrCodeView){
                EmptyView()
            }


            Spacer()

            HStack() {
                Image("InfoCheckWithMan")
                    .resizable()
                    .scaledToFit()
                    .frame(height: imageHeight, alignment: .center)

            }.padding(.bottom, 50)
            Spacer()

            VStack {

                LendInfoView(title: title, money: money, endTime: endTime)
                    .frame(width: squareTextBoxSize, height: squareTextBoxSize)
                    .padding(.top)

                NavigationLink(destination: CreateQrCodeView(qrImage: createdQrImage, documentPath: documentPath)) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                        .padding()
                        .accentColor(Color.black)
                        .background(Color.white)
                        .cornerRadius(40)
                        .shadow(color: qrcodeButtonShadowColor, radius: 10)
                        .onTapGesture {
                            isPkhudProgress = true
                            Task{
                                do{
                                    // この辺りリファクタリングしたい（ViewModelにまとめたい）
                                    confirmLendInfoViewModel.registerPayTask.payTaskDocumentPath = NSUUID().uuidString
                                    // CreateQrCodeViewに渡す用のパス
                                    self.documentPath = confirmLendInfoViewModel.registerPayTask.payTaskDocumentPath
                                    // QRコード生成
                                    try await confirmLendInfoViewModel.fetchQrCode()

                                    // CreateQrCodeViewに渡す用のイメージ
                                    self.createdQrImage = Image(uiImage: UIImage(data: confirmLendInfoViewModel.qrDecodedData ) ?? UIImage())
                                    try await confirmLendInfoViewModel.createPayTaskToFirestore(title: title, money: Int(money) ?? 0, endTime: endTime)

                                    isPkhudProgress = false
                                    // CreateQrCodeの画面に遷移
                                    toCreateQrCodeView = true

                                } catch {
                                    isPkhudProgress = false
                                    isPkhudFailure = true
                                    print("PayTaskの登録エラー", error)
                                }
                            }
                        }
                }
                .offset(x: qrcodeButtonOffsetXSize, y: qrcodeButtonOffsetYSize)
            }
            .offset(x: 0, y: -offsetSize)

            Spacer()
        }
        .PKHUD(isPresented: $isPkhudProgress, HUDContent: .labeledProgress(title: "QR作成中", subtitle: "QRコードを作成中です"), delay: .infinity)
        .PKHUD(isPresented: $isPkhudFailure, HUDContent: .labeledError(title: "エラー", subtitle: "QR作成に失敗しました。\nもう一度やり直して下さい。"), delay: 1.5)
    }
}

//struct ConfirmLendInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmLendInfoView(title: Binding("お好み焼き代"), money: Binding(4850), endTime: Binding(Date()))
//    }
//}
