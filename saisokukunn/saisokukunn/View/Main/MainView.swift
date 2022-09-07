//
//  MainView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI
import Firebase
import PKHUD

enum LendListAlertType {
    case lendInfo
    case payCompleted
}

// ConfirmQrCodeInfoViewから戻るために必要
class EnvironmentData: ObservableObject {
    @Published var isMainActiveEnvironment: Binding<Bool> = Binding<Bool>.constant(false)
}

struct MainView: View {
    @State var isMainActive: Bool = false
    @EnvironmentObject var environmentData: EnvironmentData
    @Binding var isActiveSignUpView: Bool
    @State private var isPkhudProgress = false
    @State var timer: Timer?

    @State var selectedLoanIndex: Int = 0
    @State var isAddLoanButton: Bool = false
    @State var isScanButton: Bool = false
    @State private var isBorrowInfoAlert: Bool = false
    @State private var isLendAlert: Bool = false  // enumで定義した２種類のアラートに更に分岐する
    @State private var lendListAlertType = LendListAlertType.lendInfo
    @State private var isShowingUserDeleteAlert: Bool = false
    @State private var totalBorrowingMoney: Int = 0
    @State private var totalLendingMoney: Int = 0
    @AppStorage("userName") var userName: String = ""

    @State private var borrowPayTaskList = [PayTask]()
    @State private var lendPayTaskList = [PayTask]()

    let registerUser = RegisterUser()
    let loadPayTask = LoadPayTask()
    let loadUser = LoadUser()

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
                                            try await registerUser.signOut()
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

                        NavigationLink(destination: RegisterLendInfoView()) {
                            Image(systemName: addLoanSystemImageName)
                                .padding()
                                .accentColor(Color.black)
                                .background(Color.white)
                                .cornerRadius(25)
                                .shadow(color: Color.white, radius: 10, x: 0, y: 3)
                        }

                        NavigationLink(destination: ThrowQrCodeScannerViewController(),  isActive: $isMainActive) {
                            Button(action: {
                                isMainActive = true
                                environmentData.isMainActiveEnvironment = $isMainActive

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
                            Text(String.localizedStringWithFormat("%d", totalBorrowingMoney))
                                .font(.custom(loanTotalMoneyCustomFont, size: 30))
                                .fontWeight(.heavy)
                                .foregroundColor(Color(UIColor.white))
                                .font(.title)
                                .bold()
                        } else {
                            // TODO: トータルの金額を表示したい
                            Text(String.localizedStringWithFormat("%d", totalLendingMoney))
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
                            if borrowPayTaskList.count != 0 {
                                List{
                                    Section {
                                        // 借り手の残高を表示
                                        ForEach(0 ..< borrowPayTaskList.count,  id: \.self) { index in
                                            Button(action: {
                                                self.isBorrowInfoAlert = true
                                            }, label: {
                                                BorrowListView(title: borrowPayTaskList[index].title,
                                                             person: borrowPayTaskList[index].lenderUserName ?? "",
                                                             money: borrowPayTaskList[index].money,
                                                             limitDay: createLimitDay(endTime: borrowPayTaskList[index].endTime))
                                                .frame(height: 70)
                                                .listRowBackground(Color.clear)
                                            }).alert(isPresented: self.$isBorrowInfoAlert) {
                                                Alert(title: Text("借りている詳細"),
                                                      message: Text("""
                                                                    \(createStringDate(timestamp: borrowPayTaskList[index].createdAt))〜\(createStringDate(timestamp: borrowPayTaskList[index].endTime))
                                                                    \(borrowPayTaskList[index].title)
                                                                    \(borrowPayTaskList[index].money)円
                                                                    \(borrowPayTaskList[index].lenderUserName ?? "")さん
                                                                    残り\(createLimitDay(endTime: borrowPayTaskList[index].endTime))日
                                                                    """),
                                                      dismissButton: .default(Text("OK"))
                                                )
                                            }
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

                                    Text("現在、誰にもお金を借りていません")
                                        .foregroundColor(textColor)
                                        .font(.callout)
                                    
                                }
                                .listStyle(.insetGrouped)
                                .ignoresSafeArea()
                                Spacer()
                            }

                        } else {

                            if lendPayTaskList.count != 0 {
                                List{
                                    Section {
                                        // TODO: QRスキャン後に表示したい（近藤タスク）
                                        ForEach(0 ..< lendPayTaskList.count,  id: \.self) { index in
                                            Button(action: {
                                                self.isLendAlert = true
                                                self.lendListAlertType = .lendInfo
                                            }, label: {
                                                LendListView(title: lendPayTaskList[index].title,
                                                             person: lendPayTaskList[index].borrowerUserName ?? "",
                                                             money: lendPayTaskList[index].money,
                                                             limitDay: createLimitDay(endTime: lendPayTaskList[index].endTime),
                                                             isPayCompletedAlert: $isLendAlert,
                                                             lendListAlertType: $lendListAlertType)
                                                .frame(height: 70)
                                                .listRowBackground(Color.clear)


                                            })
                                            .alert(isPresented: self.$isLendAlert) {
                                                switch lendListAlertType {
                                                case .lendInfo:
                                                    return Alert(title: Text("貸している詳細"),
                                                                 message: Text("""
                                                                               \(createStringDate(timestamp: lendPayTaskList[index].createdAt))〜\(createStringDate(timestamp: lendPayTaskList[index].endTime))
                                                                               \(lendPayTaskList[index].title)
                                                                               \(lendPayTaskList[index].money)円
                                                                               \(lendPayTaskList[index].borrowerUserName ?? "")さん
                                                                               残り\(createLimitDay(endTime: lendPayTaskList[index].endTime))日
                                                                               """),
                                                                 dismissButton: .default(Text("OK"))
                                                           )
                                                case .payCompleted:
                                                    return Alert(title: Text("完了"),
                                                                 message: Text("貸したお金は返済されましたか？"),
                                                                 primaryButton: .cancel(Text("キャンセル")),
                                                                 secondaryButton: .destructive(Text("完了"), action: {lendPayTaskList[index].isFinished = true}))
                                                }

                                            }

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
            }
        }
        .PKHUD(isPresented: $isPkhudProgress, HUDContent: .progress, delay: .infinity)
        .onAppear {

            // 5秒おきに通信を行う処理
            // 貸し側が削除された際に自動で借りを削除させる必要があるため。
            timer = Timer.scheduledTimer(withTimeInterval: 5.0, repeats: true) { _ in
                // Firestoreから借りているPayTaskの情報を取得する
                loadPayTask.fetchBorrowPayTask { borrowPayTasks, error in
                    if let error = error {
                        print("borrowPayTasksの取得に失敗",error)
                    }
                    guard let borrowPayTasks = borrowPayTasks else { return }
                    borrowPayTaskList = sortPayTasks(paytasks: borrowPayTasks)
                    // 借りている合計金額の表示
                    totalBorrowingMoney = 0
                    borrowPayTasks.forEach { borrowPayTask in
                        totalBorrowingMoney += borrowPayTask.money
                    }
                }

                // Firestoreから貸しているPayTaskの情報を取得する
                loadPayTask.fetchLenderPayTask { lendPayTasks, error in
                    if let error = error {
                        print("lendPayTaskのドキュメントid取得に失敗",error)
                    }
                    guard let lendPayTasks = lendPayTasks else { return }
                    lendPayTaskList = sortPayTasks(paytasks: lendPayTasks)
                    // 貸してる合計金額の表示
                    totalLendingMoney = 0
                    lendPayTasks.forEach { lendPayTask in
                        totalLendingMoney += lendPayTask.money
                    }
                }
            }
        }
        .onDisappear {
            timer?.invalidate()
        }
        .navigationBarHidden(true)
    }
}

// TODO: 他のモデルにぶっ込みたい
private func createLimitDay(endTime: Timestamp) -> Int {
    let endDate = endTime.dateValue()
    let now = Date()
    let limit = endDate.timeIntervalSince(now)
    var limitDay = Int(limit/60/60/24)
    if(limit>0){
        limitDay += 1
    }else{
        limitDay = 0
    }
    return Int(limitDay)
}

private func createStringDate(timestamp: Timestamp) -> String {
    let date: Date = timestamp.dateValue()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy/MM/dd"
    let dateString = formatter.string(from: date)

    return dateString
}

private func sortPayTasks(paytasks: [PayTask]) -> [PayTask] {

    var tasks = [PayTask]()
    let aaa = paytasks.sorted(by: { (a, b) -> Bool in
        return a.endTime.dateValue() < b.endTime.dateValue()
    })
    for data in aaa {
        tasks.append(data)
    }
    return tasks
}
