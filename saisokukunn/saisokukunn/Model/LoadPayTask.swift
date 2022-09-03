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
    func fetchBorrowPayTask(completion: @escaping([PayTask]?,Error?) -> Void){
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

            // TODO: なんか多分もっといい書き方があると思うので、修正したい気持ち
            borrowPayTaskIdS.forEach { borrowPayTaskId in
                self.db.collection("PayTasks").document(borrowPayTaskId).getDocument { snapShot, error in
                    if let error = error {
                        print("FirestoreからPayTaskの取得に失敗",error)
                    }
                    print("FirestoreからPayTaskの取得に成功")
                    guard let data = snapShot?.data() else { return }
                    var payTask = PayTask(dic: data)

                    let lenderUID = data["lenderUID"] as? String
                    guard let isTaskFinished = data["isTaskFinished"] as? Bool else { return }

                    // isTaskFinishedがfalseかつlenderUIDがあればpayTasksに追加
                    if !isTaskFinished && lenderUID != nil {
                        payTask.lenderUID = lenderUID
                        payTasks.append(payTask)

                        if (payTasks.count == borrowPayTaskIdS.count){
                            completion(payTasks,nil)
                        }

                    }
                }
            }
        }
    }
}

