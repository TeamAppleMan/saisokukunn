//
//  MainView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI

struct Person {
    var title: String
    var name: String
    var money: Int
    var stateDate: Date
    var endDate: Date
}


struct MainView: View {
    @State var selectedLoanIndex: Int = 0
    @State var isAddLoanButton: Bool = false
    @State var isScanButton: Bool = false
    @State var isPressedAccount: Bool = false
    @State var accountName: String = "サインアウト"
    @State var totalLendingMoney: Int = 58000
    @State var totalBorrowingMoney: Int = 20000

    @State private var toSignUpView = false
    @State private var lendPayTaskList = [PayTask]()

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

    init(){
        //List全体の背景色の設定
        UITableView.appearance().backgroundColor = .clear
    }

    var body: some View {
        let displayBounds = UIScreen.main.bounds
        let displaywidth = displayBounds.width
        let displayheight = displayBounds.height
        let qrSystemImageName = "qrcode.viewfinder"
        let addLoanSystemImageName = "note.text.badge.plus"
        let accountButtonSystemImageName = "chevron.down"
        let yenMarkCustomFont = "Futura"
        let loanTotalMoneyCustomFont = "Futura-Bold"

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
                            Button(action: {
                                isPressedAccount.toggle()
                                Task {
                                    do {
                                        try await registerUser.signOut()
                                        toSignUpView = true
                                    }
                                    catch{
                                        print("サインインに失敗",error)
                                    }
                                }// Taskここまで
                            })
                            {
                                HStack {
                                    Text("サインアウト")
                                        .font(.callout)
                                        .foregroundColor(Color(UIColor.white))
                                    Image(systemName: accountButtonSystemImageName)
                                        .foregroundColor(Color(UIColor.gray))
                                }
                            }
                            NavigationLink(destination: SignUpView(),isActive: $toSignUpView){
                                EmptyView()
                            }
                            .padding()

                            Spacer()

                            NavigationLink(destination: RegisterLendInfoView()) {
                                Image(systemName: addLoanSystemImageName)
                            }
                            .padding()
                            .accentColor(Color.black)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(color: Color.white, radius: 10, x: 0, y: 3)

                            NavigationLink(destination: QrCodeScannerView()) {
                                Image(systemName: qrSystemImageName)
                            }
                            .padding()
                            .accentColor(Color.black)
                            .background(Color.white)
                            .cornerRadius(25)
                            .shadow(color: Color.white, radius: 10, x: 0, y: 3)
                            .padding()
                        }

                        Spacer()

                        // 中央の¥表示
                        HStack {
                            Text("¥")
                                .font(.custom(yenMarkCustomFont, size: 20))
                                .foregroundColor(Color(UIColor.gray))

                            if selectedLoanIndex == 0 {
                                Text(String.localizedStringWithFormat("%d", totalLendingMoney))
                                    .font(.custom(loanTotalMoneyCustomFont, size: 30))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color(UIColor.white))
                                    .font(.title)
                                    .bold()
                            } else {
                                Text(String.localizedStringWithFormat("%d", totalBorrowingMoney))
                                    .font(.custom(loanTotalMoneyCustomFont, size: 30))
                                    .fontWeight(.heavy)
                                    .foregroundColor(Color(UIColor.white))
                                    .font(.title)
                            }
                        }

                        HStack {
                            Spacer(minLength: displaywidth/2)

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
                    .frame(height: 3*displayheight/11)

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
                                List{
                                    Section {
                                        // TODO: limitDay（残り日数）を適当に代入している。計算ロジックをつけたい。
                                        ForEach(0 ..< lendPayTaskList.count,  id: \.self) { index in
                                            LoanListView(title: lendPayTaskList[index].title, person: "ダミー", money: Int(lendPayTaskList[index].money) ?? 0, limitDay: 2)
                                                .frame(height: 70)
                                                .listRowBackground(Color.clear)
                                        }
                                    }.listRowSeparator(.hidden)
                                }
                                .listStyle(.insetGrouped)
                                .ignoresSafeArea()
                            } else {
                                List{
                                    Section {
                                        // TODO: limitDay（残り日数）を適当に代入している。計算ロジックをつけたい。
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
                // 貸しているタスクを取得する
                loadPayTask.fetchLendPayTask { lendPayTasks, error in
                    if let error = error {
                        print("貸しているタスクの取得に失敗",error)
                        return
                    }
                    guard let lendPayTasks = lendPayTasks else { return }
                    lendPayTaskList = lendPayTasks
                }
            }
        }.navigationBarHidden(true)
    }
}

struct MainView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
