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
    @State private var isActiveSignUpView = false
    @State private var userName = String()
    @State private var isPkhudProgress = false
    @State private var isPkhudFailure = false
    @State private var isNotCharactersAlert = false

    let registerUser = RegisterUser()

    var body: some View{
        let textColor = Color.init(red: 0.3, green: 0.3, blue: 0.3)
        let inputAccessoryHorizontalMargin = 25.0

        let displayBounds = UIScreen.main.bounds
        let displayHeight = displayBounds.height
        let imageHeight = displayHeight/3.25

        NavigationView{

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
                    }.padding(inputAccessoryHorizontalMargin)

                    NavigationLink(destination: MainView(isActiveSignUpView: $isActiveSignUpView), isActive: $isActiveSignUpView){
                        Button(action: {
                            // 前後の空白を消すコード
                            userName = userName.trimmingCharacters(in: .whitespaces)
                            if userName.isEmpty {
                                isNotCharactersAlert = true
                                return
                            } else {
                                isNotCharactersAlert = false
                            }

                            isPkhudProgress = true
                            Task{
                                do{
                                    try await registerUser.signIn(userName:userName)
                                    // MainViewへ画面遷移
                                    isPkhudProgress = false
                                    isActiveSignUpView = true
                                }
                                catch{
                                    isPkhudFailure = true
                                }
                            }
                        }) {
                            Text("アカウント登録")
                                .frame(width: 150.0, alignment: .center)
                                .padding()
                                .accentColor(Color.white)
                                .background(Color.gray)
                                .cornerRadius(25)
                                .shadow(color: Color.gray, radius: 10, x: 0, y: 3)
                                .padding()
                        }.alert("エラー", isPresented: $isNotCharactersAlert){
                            Button("キャンセル"){
                            }
                            Button("確認"){
                            }
                        } message: {
                            Text("１文字以上入力して下さい")
                        }

                    }

                   Spacer()

                }

            }
            .PKHUD(isPresented: $isPkhudProgress, HUDContent: .labeledProgress(title: "作成中", subtitle: "アカウントを作成中です"), delay: .infinity)
            .PKHUD(isPresented: $isPkhudFailure, HUDContent: .labeledError(title: "失敗", subtitle: "アカウント作成に失敗しました"), delay: .infinity)
            .onAppear {
                // uidが存在するならMainViewへ移動
                if let uid = Auth.auth().currentUser?.uid {
                    print("uid:",uid)
                    isActiveSignUpView = true
                }
            }// onAppearここまで
            .onTapGesture { UIApplication.shared.closeKeyboard() }

        }
        .navigationBarHidden(true)

    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
