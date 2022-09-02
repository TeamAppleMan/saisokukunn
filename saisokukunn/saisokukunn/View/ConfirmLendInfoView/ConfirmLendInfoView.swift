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
    @State private var toCreateQrCodeView = false
    @State private var isPresentedProgressView = false
    @State var qrImage: Image

    let registerPayTask = RegisterPayTask()

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

            Spacer()

            HStack() {
                Image("InfoCheckWithMan")
                    .resizable()
                    .scaledToFit()
                    .frame(height: imageHeight, alignment: .center)
            }.padding(.bottom, 50)

            Spacer()

            // CreateQrCodeに遷移する時にqrの画像を渡す
            NavigationLink(destination: CreateQrCodeView(qrImage: qrImage),isActive: $toCreateQrCodeView){
                EmptyView()
            }
            ZStack {
                if isPresentedProgressView {
                    ProgressView().progressViewStyle(CircularProgressViewStyle())
                }
            }

            VStack {
                LendInfoView(title: title, money: money, endTime: endTime)
                    .frame(width: squareTextBoxSize, height: squareTextBoxSize)
                    .padding(.top)

                NavigationLink(destination: CreateQrCodeView(qrImage: qrImage)) {
                    Image(systemName: "qrcode.viewfinder")
                        .font(.largeTitle)
                        .padding()
                        .accentColor(Color.black)
                        .background(Color.white)
                        .cornerRadius(40)
                        .shadow(color: qrcodeButtonShadowColor, radius: 10)
                        .onTapGesture {
                            isPresentedProgressView.toggle()
                            Task{
                                do{
                                    // QRコード生成
                                    let qrDecodedData = try await registerPayTask.fetchQrCode()
                                    qrImage = Image(uiImage: UIImage(data: qrDecodedData ) ?? UIImage())
                                    try await registerPayTask.createPayTaskToFirestore(title: title, money: Int(money) ?? 0, endTime: endTime)

                                    // CreateQrCodeの画面に遷移
                                    toCreateQrCodeView = true

                                    // Progress停止
                                    isPresentedProgressView.toggle()
                                } catch {
                                    print("PayTaskの登録エラー",error)
                                }
                            }
                        }
                }
                .offset(x: qrcodeButtonOffsetXSize, y: qrcodeButtonOffsetYSize)
            }
            .offset(x: 0, y: -offsetSize)

            Spacer()
        }
    }
}

//struct ConfirmLendInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        ConfirmLendInfoView(title: Binding("お好み焼き代"), money: Binding(4850), endTime: Binding(Date()))
//    }
//}
