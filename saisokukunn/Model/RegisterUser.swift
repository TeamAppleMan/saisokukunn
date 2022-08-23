//
//  RegisterUser.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/08/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class RegisterUser {
    let db = Firestore.firestore()

    func signIn(userName: String) async{
        // 匿名サインイン
        do{
            let signInResult = try await Auth.auth().signInAnonymously()
            print("匿名サインイン成功")
            let uid = signInResult.user.uid
            try await createdUserToFirestore(userName: userName, uid: uid)
        }
        catch{
            print("匿名サインイン失敗",error)
        }
    }

    private func createdUserToFirestore(userName: String,uid: String) async throws{
        let user: Dictionary<String, Any> = ["userName": userName,
                                             "uid": uid,
                                             "createdAt": Timestamp()]
        do{
            try await db.collection("Users").document(uid).setData(user)
            print("Userデータの送信に成功しました")
        }catch{
            print("Userデータの送信に失敗しました")
        }
    }
}
