//
//  SettingView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/11/06.
//

// https://www.yururiwork.net/archives/511

import SwiftUI
import PKHUD

struct SettingView: View {

    @State private var isOn = false
    @State private var pickerSelection = 0

    @ObservedObject var mainViewModel = MainViewModel()
    @EnvironmentObject var environmentData: EnvironmentData
    @Binding var isActiveSignUpView: Bool
    @State private var isPkhudProgress = false
    @State private var isShowingUserDeleteAlert = false
    @AppStorage("userName") var userName: String = ""

    private let privacyUrlString = "https://local-tumbleweed-7ea.notion.site/3a50d6e71760439fb3094f604ec4fb03"
    private let ruleUrlString = "https://local-tumbleweed-7ea.notion.site/48272533aecd40dfbca9acfed45c7584"
    private let howToUseUrlString = "https://local-tumbleweed-7ea.notion.site/72c97a2918104421b8354733eec5515f"
    private let inquiryUrlString = "https://forms.gle/R9apGP4CzrfKKX5c9"

    init(isActiveSignUpView: Binding<Bool>) {
        //List全体の背景色の設定
        UITableView.appearance().backgroundColor = .clear
        self._isActiveSignUpView = isActiveSignUpView
    }

    var body: some View {
        Form {
            Section(header: Text("情報")) {
                Button(action: {
                    if let url = URL(string: privacyUrlString) {
                        UIApplication.shared.open(url)
                    }
                }, label: {
                    HStack {
                        Text("プライバシーポリシー")
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                })
                Button(action: {
                    if let url = URL(string: ruleUrlString) {
                        UIApplication.shared.open(url)
                    }
                }, label: {
                    HStack {
                        Text("利用規約")
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                })
                Button(action: {
                    if let url = URL(string: inquiryUrlString) {
                        UIApplication.shared.open(url)
                    }
                }, label: {
                    HStack {
                        Text("お問合せ")
                            .foregroundColor(.black)
                        Spacer()
                        Image(systemName: "chevron.right")
                    }
                })
                HStack {
                    Text("バージョン")
                    Spacer()
                    Text(Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String ?? "")
                }
            }

            Section(header: Text("削除")) {
                Button(action: {
                    isShowingUserDeleteAlert = true
                }, label: {
                    HStack {
                        Text("アカウントを削除する")
                            .foregroundColor(.red)
                    }
                }).alert(isPresented: $isShowingUserDeleteAlert) {
                    Alert(
                        title: Text("アカウント削除"),
                        message: Text("アカウントが完全に削除されます。\nこの操作は取り消せません。"),
                        primaryButton: .cancel(Text("キャンセル"), action: {
                            isShowingUserDeleteAlert = false
                        }), secondaryButton: .destructive(Text("削除"), action: {
                            isPkhudProgress = true
                            Task {
                                do {
                                    try await mainViewModel.registerUser.signOut()
                                    isPkhudProgress = false
                                    isActiveSignUpView = false
                                }
                                catch{
                                    print("サインアウトに失敗",error)
                                    isPkhudProgress = false
                                }
                            }
                        })

                    )
                }
            }
        }
        .PKHUD(isPresented: $isPkhudProgress, HUDContent: .progress, delay: .infinity)
        .navigationBarTitle("設定")
        .navigationBarTitleDisplayMode(.large)
    }


}

//struct SettingView_Previews: PreviewProvider {
//    static var previews: some View {
//        SettingView()
//    }
//}
