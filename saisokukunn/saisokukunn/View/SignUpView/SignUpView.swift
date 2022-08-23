//
//  SignUpView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI
import FirebaseAuth

struct SignUpView: View {
    @State private var isActiveMainView = false
    @State private var userName = String()

    let registerUser = RegisterUser()

    var body: some View{
        NavigationView{
            VStack{
                NavigationLink(destination: MainView(), isActive: $isActiveMainView){
                    EmptyView()
                }
                TextField("名前",text: $userName)
                    .textFieldStyle(RoundedBorderTextFieldStyle()).padding()
                Button("サインイン"){
                    Task{
                        await registerUser.signIn(userName:userName)
                        // MainViewへ画面遷移
                        isActiveMainView = true
                    }
                }
            }.onAppear{
                // uidが存在するならMainViewへ移動
                if let uid = Auth.auth().currentUser?.uid {
                    isActiveMainView = true
                }
            }// onAppearここまで
        }.navigationBarHidden(true) // NavigationViewここまで
    }
}

struct SignUpView_Previews: PreviewProvider {
    static var previews: some View {
        SignUpView()
    }
}
