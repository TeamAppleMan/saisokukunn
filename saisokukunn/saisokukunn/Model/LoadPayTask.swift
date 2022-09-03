//
//  LoadPayTask.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/08/27.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore

class LoadPayTask {

    let db = Firestore.firestore()

    // TODO: async awaitで実行したい（PayTasksがCodableを準拠できない問題があるため保留）
    func fetchBorrowPayTask(completion: @escaping([PayTask]?,Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        // TODO: isTaskFinishedがfalse, lenderUIDとborrowerUIDが存在している時のみgetするようにしたい
        // 下記のプログラム実行にはFirestoreのインデックス追加が必要です
        db.collection("PayTasks").whereField("borrowerUID",isEqualTo: "\(uid)").order(by: "createdAt", descending: true).getDocuments { snapShots, error in
            if let error = error {
                print("タスク情報の取得に失敗",error)
                return
            }
            print("タスク情報の取得に成功")
            var payTasks = [PayTask]()
            guard let snapShots = snapShots else { return }
            snapShots.documents.forEach { snapShot in
                let data = snapShot.data()
                let payTask = PayTask(dic: data)
                payTasks.append(payTask)
            }
            completion(payTasks,nil)
        }
    }

    func fetchBorrowPayTask2(completion: @escaping([PayTask]?,Error?) -> Void){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // UsersにuidでアクセスしてborrowPayTaskIdを取得
        db.collection("Users").document(uid).getDocument { snapShot, error in
            if let error = error {
                print("Firestoreからユーザの情報を取得できませんでした",error)
            }
            guard let data = snapShot?.data() else { return }
            guard let borrowPayTaskIdS = data["borrowPayTaskId"] as? [String] else { return }

            // PayTasksのロード
            borrowPayTaskIdS.forEach { borrowPayTaskId in
                <#code#>
            }
        }



        // taskIDを元にPayTasksにアクセスして、lenderUIDが存在するか＆isTaskFinishedがfalseの条件で

    }
}
