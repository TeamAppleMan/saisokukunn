//
//  MainView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI
import Firebase
import PKHUD

enum AlertType {
    case borrowInfo
    case lendLendInfo
    case payCompleted
}

// ConfirmQrCodeInfoViewから戻るために必要
class EnvironmentData: ObservableObject {
    @Published var isBorrowViewActiveEnvironment: Binding<Bool> = Binding<Bool>.constant(false)
    @Published var isLendViewActiveEnvironment: Binding<Bool> = Binding<Bool>.constant(false)
    @Published var isAddDataPkhudAlert: Bool = false
}

struct MainView: View {

    @ObservedObject var mainViewModel = MainViewModel()

    @State var isBorrowActive: Bool = false
    @State var isLendActive: Bool = false
    @EnvironmentObject var environmentData: EnvironmentData
    @Binding var isActiveSignUpView: Bool
    @State private var isPkhudProgress = false

    @State var selectedLoanIndex: Int = 0
    @State var isAddLoanButton: Bool = false
    @State var isScanButton: Bool = false

    // アラートを表示させる。１つのViewで1つのアラートしか作れない。enum用いて条件分岐させることで作れた。
    @State private var isShownAlert: Bool = false  // enumで定義した３種類のアラートに更に分岐する
    @State private var alertType = AlertType.borrowInfo
    @State private var payTask: PayTask?
    @State private var selectedIndex: Int = 0

    @State private var isShowingUserDeleteAlert: Bool = false
    @AppStorage("userName") var userName: String = ""


    init(isActiveSignUpView: Binding<Bool>) {
        //List全体の背景色の設定
        UITableView.appearance().backgroundColor = .clear
        self._isActiveSignUpView = isActiveSignUpView
    }

    var body: some View {
        let displayBounds = UIScreen.main.bounds
        let displayWidth = displayBounds.width
        let displayHeight = displayBounds.height
        let imageHeight = displayHeight/3.0
        let qrSystemImageName = "qrcode.viewfinder"
        let addLoanSystemImageName = "note.text.badge.plus"
        let accountButtonSystemImageName = "person.crop.circle"
        let yenMarkCustomFont = "Futura"
        let loanTotalMoneyCustomFont = "Futura-Bold"
        let textColor = Color.init(red: 0.3, green: 0.3, blue: 0.3)

        NavigationView {
            ZStack {
                // 背景を黒にする
                Color.init(red: 0, green: 0, blue: 0)
                    .ignoresSafeArea()

                // MARK: モーダルより上の部分
                VStack {

                    VStack {
                        // アカウント名、貸し金追加、コードスキャン
                        HStack {

                            // サインアウトボタン
                            Button(action: {
                                isShowingUserDeleteAlert = true
                            }) {
                                HStack {
                                    Image(systemName: accountButtonSystemImageName)
                                        .foregroundColor(Color(UIColor.white))
                                    Text(userName)
                                        .font(.callout)
                                        .foregroundColor(Color(UIColor.white))
                                        .lineLimit(1)
                                        .minimumScaleFactor(0.1)
                                }
                            }.alert(isPresented: $isShowingUserDeleteAlert) {
                                Alert(
                                    title: Text("アカウント削除"),
                                    message: Text("アカウントが完全に削除されます。\nこの操作は取り消せません。"),
                                    primaryButton: .cancel(Text("キャンセル"), action: {
                                        isShowingUserDeleteAlert = false
                                    }),
                                    secondaryButton: .destructive(Text("削除"), action: {
                                        isPkhudProgress = true
                                        Task {
                                            do {
                                                try await mainViewModel.registerUser.signOut()
                                                isPkhudProgress = false
                                                isActiveSignUpView = false
                                            }
                                            catch{
                                                print("サインインに失敗",error)
                                            }
                                        }

                                    })
                                )
                            }
                            .padding()


                            Spacer()

                            NavigationLink(destination: RegisterLendInfoView(), isActive: $isBorrowActive) {
                                Button(action: {
                                    isBorrowActive = true
                                    environmentData.isBorrowViewActiveEnvironment = $isBorrowActive
                                }, label: {
                                    Image(systemName: addLoanSystemImageName)
                                        .padding()
                                        .accentColor(Color.black)
                                        .background(Color.white)
                                        .cornerRadius(25)
                                        .shadow(color: Color.white, radius: 10, x: 0, y: 3)
                                })
                            }

                            NavigationLink(destination: ThrowQrCodeScannerViewController(), isActive: $isLendActive) {
                                Button(action: {
                                    isLendActive = true
                                    environmentData.isLendViewActiveEnvironment = $isLendActive

                                }, label: {
                                    Image(systemName: qrSystemImageName)
                                        .padding()
                                        .accentColor(Color.black)
                                        .background(Color.white)
                                        .cornerRadius(25)
                                        .shadow(color: Color.white, radius: 10, x: 0, y: 3)
                                        .padding()
                                })

                            }

                        }

                        Spacer()

                        // 中央の¥表示
                        HStack {
                            Text("¥")
                                .font(.custom(yenMarkCustomFont, size: 20))
                                .foregroundColor(Color(UIColor.gray))

                            if selectedLoanIndex == 0 {
                                // TODO: トータルの金額を表示したい
                                Text(String.localizedStringWithFormat("%d", mainViewModel.totalBorrowingMoney))
                                    .font(.custom(loanTotalMoneyCustomFont, size: 30))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color(UIColor.white))
                                    .font(.title)
                                    .bold()
                            } else {
                                // TODO: トータルの金額を表示したい
                                Text(String.localizedStringWithFormat("%d", mainViewModel.totalLendingMoney))
                                    .font(.custom(loanTotalMoneyCustomFont, size: 30))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color(UIColor.white))
                                    .font(.title)
                            }
                        }

                        HStack {
                            Spacer(minLength: displayWidth/2)

                            if selectedLoanIndex == 0 {
                                Text("借りた総額")
                                    .foregroundColor(Color(UIColor.gray))
                            } else {
                                Text("貸した総額")
                                    .foregroundColor(Color(UIColor.gray))
                            }

                            Spacer()
                        }
                        Spacer()

                    }

                    // 黒い部分の高さ。3分の11くらいが一番良さそうだった。（感覚）
                    .frame(height: 3*displayHeight/11)

                    Spacer()

                    // MARK: モーダル部分
                    ZStack{

                        Rectangle()
                            .foregroundColor(.white)
                            .cornerRadius(20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
                            .shadow(color: .gray, radius: 3, x: 0, y: -1)
                            .ignoresSafeArea()

                        VStack(spacing : 0) {
                            Picker("", selection: self.$selectedLoanIndex) {
                                Text("借り")
                                    .tag(0)
                                Text("貸し")
                                    .tag(1)
                            }
                            .padding([.top, .leading, .trailing], 40.0)
                            .pickerStyle(SegmentedPickerStyle())

                            if selectedLoanIndex == 0 {

                                // リストが空なら画像表示
                                if mainViewModel.borrowPayTaskList.count != 0 {

                                    List{
                                        Section {
                                            // 借り手の残高を表示
                                            ForEach(0 ..< mainViewModel.borrowPayTaskList.count,  id: \.self) { index in
                                                Button(action: {
                                                    self.payTask = mainViewModel.borrowPayTaskList[index]
                                                    self.alertType = .borrowInfo
                                                    self.isShownAlert = true
                                                }, label: {

                                                    // List表示部分
                                                    // 別のViewに書きたかったが、Alert関係でココに記述
                                                    HStack {
                                                        let limitDay = CreateLimiteDay().createLimitDay(endTime: mainViewModel.borrowPayTaskList[index].endTime)

                                                        HStack {
                                                            if limitDay < 10 {
                                                                Text("\(limitDay)")
                                                                    .offset(x: 7, y: 0)
                                                                    .font(.title2)
                                                                Text("day")
                                                                    .font(.caption2)
                                                                    .offset(x: 0, y: 5)
                                                            } else if limitDay < 100 {
                                                                Text("\(limitDay)")
                                                                    .font(.system(size: 20))
                                                                    .offset(x: 8, y: 0)
                                                                Text("day")
                                                                    .font(.system(size: 10))
                                                                    .offset(x: -2, y: 8)
                                                            } else if limitDay < 1000 {
                                                                Text("\(limitDay)")
                                                                    .font(.system(size: 15))
                                                                    .offset(x: 8, y: 0)
                                                                Text("day")
                                                                    .font(.system(size: 10))
                                                                    .offset(x: -2, y: 8)
                                                            } else {
                                                                Text("\(limitDay)")
                                                                    .font(.system(size: 10))
                                                                    .offset(x: 8, y: 0)
                                                                Text("day")
                                                                    .font(.system(size: 10))
                                                                    .offset(x: -2, y: 8)
                                                            }
                                                        }
                                                        .frame(width: 60, height: 60)
                                                        .foregroundColor(Color.gray)
                                                        .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                                                        .overlay(RoundedRectangle(cornerRadius: 35).stroke(Color.init(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 5))
                                                        .cornerRadius(35)

                                                        VStack(alignment: .leading) {
                                                            Text(mainViewModel.borrowPayTaskList[index].title)
                                                                .font(.system(.headline, design: .rounded))
                                                                .bold()
                                                            Text(mainViewModel.borrowPayTaskList[index].lenderUserName ?? "")
                                                                .foregroundColor(.gray)
                                                                .font(.system(size: 10))
                                                        }

                                                        Spacer()
                                                        Text("¥ \(mainViewModel.borrowPayTaskList[index].money)")
                                                            .bold()
                                                            .padding()
                                                    }
                                                    
                                                    .frame(height: 70)
                                                    .listRowBackground(Color.clear)

                                                }
                                                )}

                                        }.listRowSeparator(.hidden)
                                    }
                                    .listStyle(.insetGrouped)
                                    .ignoresSafeArea()
                                } else {
                                    Spacer()
                                    VStack(alignment: .center) {
                                        Image("ManWithMan")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: imageHeight, alignment: .center)

                                        Text("現在、誰にもお金を借りていません")
                                            .foregroundColor(textColor)
                                            .font(.callout)

                                    }
                                    .listStyle(.insetGrouped)
                                    .ignoresSafeArea()
                                    Spacer()
                                }

                            } else {

                                if mainViewModel.lendPayTaskList.count != 0 {
                                    List{
                                        Section {
                                            // TODO: QRスキャン後に表示したい（近藤タスク）
                                            ForEach(0 ..< mainViewModel.lendPayTaskList.count,  id: \.self) { index in
                                                Button(action: {
                                                    self.payTask = mainViewModel.lendPayTaskList[index]
                                                    self.alertType = .lendLendInfo
                                                    self.isShownAlert = true
                                                }, label: {

                                                    // List表示部分
                                                    // 別のViewに書きたかったが、Alert関係でココに記述

                                                    HStack {
                                                        let limitDay = CreateLimiteDay().createLimitDay(endTime: mainViewModel.lendPayTaskList[index].endTime)
                                                        HStack {
                                                            if limitDay < 10 {
                                                                Text("\(limitDay)")
                                                                    .offset(x: 7, y: 0)
                                                                    .font(.title2)
                                                                Text("day")
                                                                    .font(.caption2)
                                                                    .offset(x: 0, y: 5)
                                                            } else if limitDay < 100 {
                                                                Text("\(limitDay)")
                                                                    .font(.system(size: 20))
                                                                    .offset(x: 8, y: 0)
                                                                Text("day")
                                                                    .font(.system(size: 10))
                                                                    .offset(x: -2, y: 8)
                                                            } else if limitDay < 1000 {
                                                                Text("\(limitDay)")
                                                                    .font(.system(size: 15))
                                                                    .offset(x: 8, y: 0)
                                                                Text("day")
                                                                    .font(.system(size: 10))
                                                                    .offset(x: -2, y: 8)
                                                            } else {
                                                                Text("\(limitDay)")
                                                                    .font(.system(size: 10))
                                                                    .offset(x: 8, y: 0)
                                                                Text("day")
                                                                    .font(.system(size: 10))
                                                                    .offset(x: -2, y: 8)
                                                            }
                                                        }
                                                        .frame(width: 60, height: 60)
                                                        .foregroundColor(Color.gray)
                                                        .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                                                        .overlay(RoundedRectangle(cornerRadius: 35).stroke(Color.init(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 5))
                                                        .cornerRadius(35)

                                                        VStack(alignment: .leading) {
                                                            Text(mainViewModel.lendPayTaskList[index].title)
                                                                .font(.system(.headline, design: .rounded))
                                                                .bold()
                                                            Text(mainViewModel.lendPayTaskList[index].borrowerUserName ?? "")
                                                                .foregroundColor(.gray)
                                                                .font(.system(size: 10))
                                                        }

                                                        Spacer()
                                                        Text("¥ \(mainViewModel.lendPayTaskList[index].money)")
                                                            .bold()
                                                            .padding()

                                                        Button(action: {
                                                            self.selectedIndex = index
                                                            self.payTask = mainViewModel.lendPayTaskList[index]
                                                            self.alertType = .payCompleted
                                                            self.isShownAlert = true
                                                        }, label: {
                                                            Image(systemName: "x.circle")
                                                        })

                                                    }
                                                    .frame(height: 70)
                                                    .listRowBackground(Color.clear)

                                                })
                                            }
                                        }.listRowSeparator(.hidden)
                                    }
                                    .listStyle(.insetGrouped)
                                    .ignoresSafeArea()
                                } else {
                                    Spacer()
                                    VStack(alignment: .center) {
                                        Image("ManWithMan")
                                            .resizable()
                                            .scaledToFit()
                                            .frame(height: imageHeight, alignment: .center)

                                        Text("現在、誰にもお金を貸していません")
                                            .foregroundColor(textColor)
                                            .font(.callout)

                                    }
                                    .listStyle(.insetGrouped)
                                    .ignoresSafeArea()
                                    Spacer()
                                }
                            }
                        }
                    }
                    // アラート表示, ３つの場合分け
                    // TODO: アラート表示内容変える。強制アンラップはやめよう。
                    .alert(isPresented: $isShownAlert) {
                        print("selectedIndex:",selectedIndex)
                        switch alertType {
                        case .borrowInfo:
                            return Alert(title: Text("借り詳細"),
                                         message: Text("""
                                                       \(createStringDate(timestamp: payTask!.createdAt))〜\(createStringDate(timestamp: payTask!.endTime))
                                                       \(payTask!.title)
                                                       \(payTask!.money)円
                                                       〇〇さん
                                                       残り〇〇日
                                                       """))
                        case .lendLendInfo:
                            return Alert(title: Text("貸し詳細"),
                                         message: Text("""
                                                       \(createStringDate(timestamp: payTask!.createdAt))〜\(createStringDate(timestamp: payTask!.endTime))
                                                       \(payTask!.title)
                                                       \(payTask!.money)円
                                                       〇〇さん
                                                       残り〇〇日
                                                       """))
                        case .payCompleted:
                            return Alert(title: Text("完了"),
                                         message: Text("貸したお金は返済されましたか？"),
                                         primaryButton: .cancel(Text("キャンセル")),
                                         secondaryButton: .destructive(
                                            Text("完了"),
                                            action: {
                                                // isFinishedをfalseにする作業
                                                let documentPath = mainViewModel.lendPayTaskList[selectedIndex].documentPath
                                                Task{
                                                    do{
                                                        try await mainViewModel.registerPayTask.updateIsFinishedPayTask(documentPath: documentPath)
                                                    }catch{
                                                        print("isFinishedの更新に失敗")
                                                    }
                                                }
                                            }
                                         )
                            )
                        }
                    }
                }

        }
        .PKHUD(isPresented: $isPkhudProgress, HUDContent: .progress, delay: .infinity)
        .PKHUD(isPresented: $environmentData.isAddDataPkhudAlert, HUDContent: .labeledSuccess(title: "成功", subtitle: "データが追加されました"), delay: 1.5)
        .onAppear {
            mainViewModel.fetchBorrowPayTask()
            mainViewModel.fetchLenderPayTask()
        }
        .navigationBarHidden(true)
    }
}
}

private func createStringDate(timestamp: Timestamp) -> String {
    let date: Date = timestamp.dateValue()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let dateString = formatter.string(from: date)

    return dateString
}
