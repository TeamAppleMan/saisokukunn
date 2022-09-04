//
//  SignUpView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var isActiveSignUpView = false
    @State private var userName = String()
    @State private var isPresentedProgressView = false

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

                // インジケータ
                ZStack{
                    if isPresentedProgressView{
                        ProgressView()
                            .scaleEffect(x: 2,y: 2, anchor: .center)
                    }
                }

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
                            isPresentedProgressView.toggle()
                            Task{
                                do{
                                    try await registerUser.signIn(userName:userName)
                                    // MainViewへ画面遷移
                                    isPresentedProgressView.toggle()
                                    isActiveSignUpView = true
                                }
                                catch{
                                    print("サインインに失敗しました")
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
                        }
                    }

                   Spacer()

                }

            }.onAppear {
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
