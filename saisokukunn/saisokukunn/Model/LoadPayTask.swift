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

    // 配列をロード
    // TODO: async awaitで実行したい（PayTasksがCodableを準拠できない問題があるため保留）
    func fetchBorrowPayTask(completion: @escaping([PayTask]?,Error?) -> Void) {
        guard let lenderUID = Auth.auth().currentUser?.uid else { return }

        db.collection("PayTasks").whereField("lenderUID",isEqualTo: "\(lenderUID)").order(by: "createdAt", descending: true).getDocuments { snapShots, error in
            if let error = error {
                print("タスク情報の取得に失敗",error)
                return
            }
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

    func fetchBorrowPayTask(){
        
    }
}
