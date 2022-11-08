//
//  SignUpView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI
import FirebaseAuth
import PKHUD

struct SignUpView: View {

    @ObservedObject var signUpViewModel = SignUpViewModel()

    @State private var isActiveSignUpView = false
    @AppStorage("userName") private var userName = String()
    @State private var email = String()
    @State private var password = String()
    @State private var isPkhudProgress = false
    @State private var isPkhudFailure = false

    var body: some View{
        let textColor = Color.init(red: 0.3, green: 0.3, blue: 0.3)
        let inputAccessoryHorizontalMargin = 25.0
        let mainView = MainView(isActiveSignUpView: $isActiveSignUpView)
        let thinGrayColor = Color.init(red: 0.92, green: 0.92, blue: 0.92)

        let displayBounds = UIScreen.main.bounds
        let displayHeight = displayBounds.height
        let imageHeight = displayHeight/3.25

        VStack{

            // 上半分を画像
            VStack {
                HStack() {
                    Image("InputUsernameWithMan")
                        .resizable()
                        .scaledToFit()
                        .frame(height: imageHeight, alignment: .center)
                }
            }.padding(.bottom, 50)

            // 下半分をインプット部分
            VStack {

                VStack(alignment: .leading, spacing: 5) {
                    Text("表示名")
                        .foregroundColor(textColor)
                    TextField("表示名を入力して下さい。",text: $userName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(10)
                    Text("メールアドレス")
                        .foregroundColor(textColor)
                    TextField("メールアドレスを入力して下さい。",text: $email)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(10)
                    Text("パスワード")
                        .foregroundColor(textColor)
                    TextField("パスワードを入力して下さい。",text: $password)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .padding(10)
                }.padding(inputAccessoryHorizontalMargin)

                Button(action: {
                    // PKHUDの表示
                    isPkhudProgress = true
                    Task{
                        do{
                            try await signUpViewModel.signIn(userName: userName.replacingOccurrences(of: "　", with: " "), email: email, password: password)
                            // MainViewへ画面遷移
                            isPkhudProgress = false
                            isActiveSignUpView = true
                        }
                        catch{
                            isPkhudProgress = false
                            isPkhudFailure = true
                        }
                    }
                }) {

                    Text("アカウント登録")
                        .frame(width: 150.0, alignment: .center)
                        .padding()
                        .accentColor(userName.isEmpty || !signUpViewModel.validateEmail(candidate: email) || !signUpViewModel.validatePassword(candidate: password) ? Color.black : Color.white)
                        .background(userName.isEmpty || !signUpViewModel.validateEmail(candidate: email) || !signUpViewModel.validatePassword(candidate: password) ?  thinGrayColor: Color.gray)
                        .cornerRadius(25)
                        .shadow(color: userName.isEmpty || !signUpViewModel.validateEmail(candidate: email) || !signUpViewModel.validatePassword(candidate: password) ? Color.white : Color.gray, radius: 10, x: 0, y: 3)
                        .padding()
                }
                .disabled(userName.isEmpty || !signUpViewModel.validateEmail(candidate: email) || !signUpViewModel.validatePassword(candidate: password))
                .fullScreenCover(isPresented: $isActiveSignUpView) {
                    mainView.environmentObject(EnvironmentData())
                }

            }

        }
        .PKHUD(isPresented: $isPkhudProgress, HUDContent: .progress, delay: .infinity)
        .PKHUD(isPresented: $isPkhudFailure, HUDContent: .labeledError(title: "エラー", subtitle: "アカウント作成失敗\nやり直して下さい"), delay: 1.5)
        .onAppear {
            print("here")
            // uidが存在するならMainViewへ移動
            if let uid = Auth.auth().currentUser?.uid {
                print("uid:",uid)
                isActiveSignUpView = true
            }
        }// onAppearここまで
        .onTapGesture { UIApplication.shared.closeKeyboard() }
    }
}
