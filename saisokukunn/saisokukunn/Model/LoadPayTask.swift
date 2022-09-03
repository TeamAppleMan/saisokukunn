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
            print("Firestoreからユーザの情報を取得しました")
            guard let data = snapShot?.data() else { return }
            guard let borrowPayTaskIdS = data["borrowPayTaskId"] as? [String] else { return }
            var payTasks = [PayTask]()
            for index in 0..<borrowPayTaskIdS.count {
                self.db.collection("PayTasks").document(borrowPayTaskIdS[index]).getDocument { snapShot, error in
                    if let error = error {
                        print("FirestoreからPayTaskの取得に失敗",error)
                    }
                    print("FirestoreからPayTaskの取得に成功")
                    guard let data = snapShot?.data() else { return }
                    var payTask = PayTask(dic: data)

                    let lenderUID = data["lenderUID"] as? String
                    guard let isTaskFinished = data["isTaskFinished"] as? Bool else { return }

                    // isTaskFinishedがfalseかつlenderUIDがあれば
                    if !isTaskFinished && lenderUID != nil {
                        payTask.lenderUID = lenderUID
                        payTasks.append(payTask)
                        print("index",index)
                        if (payTasks.count == borrowPayTaskIdS.count-1){
                            print("indexComplete",index)
                            completion(payTasks,nil)
                        }
                    }
                }
            }

        }
    }
}

