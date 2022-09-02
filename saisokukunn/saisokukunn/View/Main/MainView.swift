//
//  MainView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI
import Firebase

struct Person {
    var title: String
    var name: String
    var money: Int
    var stateDate: Date
    var endDate: Date
}

// ConfirmQrCodeInfoViewから戻るために必要
class EnvironmentData: ObservableObject {
    @Published var isMainActiveEnvironment: Binding<Bool> = Binding<Bool>.constant(false)
}

struct MainView: View {
    @State var isMainActive: Bool = false
    @EnvironmentObject var environmentData: EnvironmentData
    @Binding var isActiveSignUpView: Bool

    @State var selectedLoanIndex: Int = 0
    @State var isAddLoanButton: Bool = false
    @State var isScanButton: Bool = false
    @State var isPressedAccount: Bool = false
    @State var accountName: String = "サインアウト"
    @State private var totalBorrowingMoney: Int = 0
    @State private var totalLendingMoney: Int = 0

    @State private var toSignUpView = false
    @State private var borrowPayTaskList = [PayTask]()

    let registerUser = RegisterUser()
    let loadPayTask = LoadPayTask()

    var lendPersons = [
        Person.init(title: "お好み焼", name: "有村架純", money: 5000, stateDate: Date(), endDate: Date()),
        Person.init(title: "お好み焼", name: "広瀬すず", money: 2500, stateDate: Date(), endDate: Date()),
        Person.init(title: "お好み焼", name: "浜辺美波", money: 50000, stateDate: Date(), endDate: Date()),
        Person.init(title: "お好み焼", name: "新垣結衣", money: 300, stateDate: Date(), endDate: Date())
    ]

    var borrowPersons = [
        Person.init(title: "お好み焼", name: "新田真剣佑", money: 12300, stateDate: Date(), endDate: Date()),
        Person.init(title: "お好み焼", name: "小栗旬", money: 1000, stateDate: Date(), endDate: Date()),
        Person.init(title: "お好み焼", name: "松坂桃李", money: 2000, stateDate: Date(), endDate: Date()),
    ]

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
        let accountButtonSystemImageName = "chevron.down"
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
                            isActiveSignUpView = false
                            isPressedAccount.toggle()
                            Task {
                                do {
                                    try await registerUser.signOut()
                                    toSignUpView = true
                                }
                                catch{
                                    print("サインインに失敗",error)
                                }
                            }
                        }) {
                            HStack {
                                Text("サインアウト")
                                    .font(.callout)
                                    .foregroundColor(Color(UIColor.white))
                                Image(systemName: accountButtonSystemImageName)
                                    .foregroundColor(Color(UIColor.gray))
                            }
                            .padding()
                        }


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
                                            LoanListView(title: borrowPayTaskList[index].title, person: "ダミー", money: borrowPayTaskList[index].money,limitDay: createLimitDay(endTime: borrowPayTaskList[index].endTime))
                                                .frame(height: 70)
                                                .listRowBackground(Color.clear)
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

                            // TODO: List空時に表示させる画像は、貸してくれるListに限って未設定。変数完成後実装させる。
                            List{
                                Section {
                                    // TODO: QRスキャン後に表示したい（近藤タスク）
                                    ForEach(0 ..< borrowPersons.count,  id: \.self) { index in
                                        LoanListView(title: borrowPersons[index].title, person: borrowPersons[index].name, money: borrowPersons[index].money, limitDay: 3)
                                            .frame(height: 70)
                                            .listRowBackground(Color.clear)
                                    }
                                }.listRowSeparator(.hidden)
                            }
                            .listStyle(.insetGrouped)
                            .ignoresSafeArea()
                        }
                    }
                }
            }
        }.onAppear{
            // Firestoreから借りているPayTaskの情報を取得する
            loadPayTask.fetchBorrowPayTask { borrowPayTasks, error in
                if let error = error {
                    print("貸しているタスクの取得に失敗",error)
                    return
                }
                guard let borrowPayTasks = borrowPayTasks else { return }
                print("borrowPayTasks:",borrowPayTasks)
                borrowPayTaskList = borrowPayTasks
                // 借りている合計金額の表示
                borrowPayTasks.forEach { borrowPayTask in
                    totalBorrowingMoney += borrowPayTask.money
                }
            }



            // TODO: Firestoreから貸しているPayTaskの情報を取得する（近藤タスク）
        }.navigationBarHidden(true)
    }
}

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

    //struct MainView_Previews: PreviewProvider {
    //    static var previews: some View {
    //        MainView()
    //    }
    //}
