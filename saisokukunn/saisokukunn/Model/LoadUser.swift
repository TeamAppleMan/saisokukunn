//
//  LoadUser.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/09/03.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoadUser {
    let db = Firestore.firestore()

    func fetchUserName(uid: String,completion: @escaping(String?,Error?) -> Void) {
        db.collection("Users").document(uid).getDocument { snapShot, error in
            if let error = error {
                print("Firestoreからユーザ情報の取得に失敗しました")
                completion(nil,error)
            }
            guard let data = snapShot?.data() else { return }
            guard let userName = data["userName"] as? String else { return }
            completion(userName,nil)
        }
    }
}
