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
                            if(try await signUpViewModel.signIn(userName: userName.replacingOccurrences(of: "　", with: " "), email: email, password: password.trimmingCharacters(in: .whitespaces))) {
                                // MainViewへ画面遷移
                                isPkhudProgress = false
                                isActiveSignUpView = true
                            } else {
                                isPkhudProgress = false
                                isPkhudFailure = true
                            }
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
                .fullScreenCover(isPresented: $isActiveSignUpView) {
                    mainView.environmentObject(EnvironmentData())
                }
                .disabled(userName.isEmpty || !signUpViewModel.validateEmail(candidate: email) || !signUpViewModel.validatePassword(candidate: password))

            }

        }
        .PKHUD(isPresented: $isPkhudProgress, HUDContent: .progress, delay: .infinity)
        .PKHUD(isPresented: $isPkhudFailure, HUDContent: .labeledError(title: "エラー", subtitle: "アカウント作成失敗\nやり直して下さい"), delay: 1.5)
        .onAppear {
            // uidが存在するならMainViewへ移動
            if let uid = Auth.auth().currentUser?.uid {
                print("uid:",uid)
                var transaction = Transaction()
                transaction.disablesAnimations = true
                withTransaction(transaction) {
                    isActiveSignUpView = true
                }
            }
        }// onAppearここまで
        .onWillAppear {
            print("呼ばれた？")
            userName = ""
            email = ""
            password = ""
        }
        .onTapGesture { UIApplication.shared.closeKeyboard() }
    }
}




/*
 MARK: 以下、ViewWillAppearを実現するために必要
 ViewWillAppear時にtextFieldを空にするために必要だった。
 */
extension View {
    func onWillAppear(_ perform: @escaping (() -> Void)) -> some View {
        self.modifier(ViewWillAppearModifier(callback: perform))
    }
}

struct ViewWillAppearHandler: UIViewControllerRepresentable {
    func makeCoordinator() -> ViewWillAppearHandler.Coordinator {
        Coordinator(onWillAppear: onWillAppear)
    }

    let onWillAppear: () -> Void

    func makeUIViewController(context: UIViewControllerRepresentableContext<ViewWillAppearHandler>) -> UIViewController {
        context.coordinator
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: UIViewControllerRepresentableContext<ViewWillAppearHandler>) {
    }

    typealias UIViewControllerType = UIViewController

    class Coordinator: UIViewController {
        let onWillAppear: () -> Void

        init(onWillAppear: @escaping () -> Void) {
            self.onWillAppear = onWillAppear
            super.init(nibName: nil, bundle: nil)
        }

        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            onWillAppear()
        }
    }
}

struct ViewWillAppearModifier: ViewModifier {
    let callback: () -> Void

    func body(content: Content) -> some View {
        content
            .background(ViewWillAppearHandler(onWillAppear: callback))
    }
}
