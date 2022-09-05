//
//  ConfirmQrCodeInfoView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI

struct ConfirmQrCodeInfoView: View {
    @EnvironmentObject var environmentData: EnvironmentData
    @State var title: String
    @State var lendPerson: String
    @State var money: String
    @State var endTime: Date
    @State var documentPath: String
    @State var showingAlert: Bool = false
    @State private var isPkhudProgress = false
    @State private var isPkhudFailure = false

    var body: some View {
        let registerPayTask = RegisterPayTask()

        let displayBounds = UIScreen.main.bounds
        let displayWidth = displayBounds.width
        let displayHeight = displayBounds.height

        let imageHeight = displayHeight/3.25
        let textBoxWidth = displayWidth - 80.0
        let textBoxHeight = 300.0
        let qrcodeButtonOffsetXSize = displayWidth/2 - 80
        let qrcodeButtonOffsetYSize = -30.0
        let qrcodeButtonShadowColor = Color.init(red: 0.4, green: 0.4, blue: 0.4)
        let textColor = Color.init(red: 0.3, green: 0.3, blue: 0.3)

        VStack(spacing: 0) {

            HStack() {
                Image("ClearWithMan")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 2*imageHeight/3, alignment: .center)
            }.offset(x: 0, y: -30)

            VStack {
                BorrowInfoView(title: title, lendPerson: lendPerson, money: money, endTime: endTime)
                    .frame(width: textBoxWidth, height: textBoxHeight)
                    .padding(.top)

                Button(action: {
                    self.showingAlert = true
                }) {
                    HStack(spacing: 5) {
                        Text("貸りる")
                        Image(systemName: "checkmark")
                    }
                    .font(.title3)
                    .padding()
                    .accentColor(textColor)
                    .background(Color.white)
                    .cornerRadius(40)
                    .shadow(color: qrcodeButtonShadowColor, radius: 10)
                }
                .alert("確認", isPresented: $showingAlert){
                    Button("キャンセル"){
                    }
                    Button("決定"){
                        isPkhudProgress = true
                        // Firestoreに貸す側のUIDをPayTaskのフィールドに送信
                        Task{
                            do{

                                try await registerPayTask.addLenderUIDToFireStore(payTaskPath: documentPath)
                                isPkhudProgress = false
                                print("PayTasksに対してlenderUIDの送信に成功しました")
                            } catch {
                                isPkhudFailure = true
                                print("PayTasksに対してlenderUIDの送信に失敗しました", error)
                            }
                        }

                        // TODO: 下記はMainViewに戻るコード（まだうまく動かない。要改善。）
                        environmentData.isMainActiveEnvironment.wrappedValue = false
                    }
                } message: {
                    Text("本当にこの内容でよろしいですか？")
                }
                .offset(x: qrcodeButtonOffsetXSize, y: qrcodeButtonOffsetYSize)
            }

            VStack(spacing: 0) {
                Text("締め切り３日前から、催促通知が届きます。")
                Text("アプリの通知をオンにしておきましょう。")
            }
            .font(.callout)
            .foregroundColor(textColor)
            .padding(.bottom)

            Spacer(minLength: 15)
        }
        .PKHUD(isPresented: $isPkhudProgress, HUDContent: .labeledProgress(title: "通信中", subtitle: "通信中です。\nしばらくお待ち下さい。"), delay: .infinity)
        .PKHUD(isPresented: $isPkhudFailure, HUDContent: .labeledError(title: "エラー", subtitle: "通信に失敗しました。\nもう一度やり直して下さい。"), delay: 1.5)
    }
}

struct ConfirmQrCodeInfoView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            ConfirmQrCodeInfoView(title: "お好み焼き代", lendPerson: "佐藤健", money: "25000", endTime: Date(), documentPath: "ダミー")
        }
    }
}
