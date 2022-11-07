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

    func signIn(userName: String,email: String,password: String) async throws -> Bool {
        // メールアドレス、パスワード、サインイン
        do{
            let signInResult = try await Auth.auth().createUser(withEmail: email, password: password)
            print("匿名サインイン成功")
            let uid = signInResult.user.uid
            try await createdUserToFirestore(userName: userName,email: email, uid: uid)
            return true
        }
        catch{
            print("匿名サインイン失敗",error)
            return false
        }
    }

    func signOut() async throws -> Bool {
        do {
            try Auth.auth().signOut()
            print("サインアウトしました")
            return true
        }
        catch {
            print("サインアウトに失敗しました",error)
            return false
        }
    }

    func deleteDocumentPath(documentPath: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await db.collection("Users").document(uid).updateData(["lendPayTaskId": FieldValue.arrayRemove([documentPath])])
    }

    private func createdUserToFirestore(userName: String,email: String,uid: String) async throws {
        guard let token = UserDefaults.standard.string(forKey: "token") else { return }
        let user: Dictionary<String, Any> = ["userName": userName,
                                             "uid": uid,
                                             "createdAt": Timestamp(),
                                             "email": email,
                                             "token": token]
        do{
            try await db.collection("Users").document(uid).setData(user)
            print("Userデータの送信に成功しました")
        }catch{
            print("Userデータの送信に失敗しました")
        }
    }
}
