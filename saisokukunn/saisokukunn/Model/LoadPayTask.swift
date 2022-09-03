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
    let loadUser = LoadUser()

    private var payTasks = [PayTask]()


    // TODO: async awaitで実行したい（PayTasksがCodableを準拠できない問題があるため保留）
    func fetchBorrowPayTask(completion: @escaping([PayTask]?,Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        // UsersにuidでアクセスしてborrowPayTaskIdを取得
        db.collection("Users").document(uid).getDocument { snapShot, error in
            if let error = error {
                print("Firestoreからユーザの情報を取得できませんでした",error)
                completion(nil,error)
            }
            print("Firestoreからユーザの情報を取得しました")
            guard let data = snapShot?.data() else { return }
            guard let borrowPayTaskIdS = data["borrowPayTaskId"] as? [String] else { return }

            // 取得したborrowPayTaskIdからPayTaskを取得
            self.loadBorrowPayTask(borrowPayTaskIdS: borrowPayTaskIdS) { payTasks, error in
                if let error = error {
                    print("borrrowPayTaskのロード失敗",error)
                }
                completion(payTasks,error)
            }
        }
    }

    func fetchBorrowPayTask2(completion: @escaping([PayTask]?,Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("PayTasks").whereField("borrowerUID", isEqualTo: uid).whereField("isTaskFinished", isEqualTo: false).order(by: "createdAt", descending: true).getDocuments { snapShots, error in
            if let error = error {
                print("FirestoreからPayTaskの取得に失敗",error)
                return
            }
            var payTasks = [PayTask]()
            snapShots?.documents.forEach({ snapShot in
                let data = snapShot.data()
                let payTask = PayTask(dic: data)
                payTasks.append(payTask)
            })
            completion(payTasks,nil)
        }
    }

    // TODO: async awaitで実行したい（上記のTODOと同様の理由）
    func fetchLenderPayTask(completion: @escaping([PayTask]?,Error?) -> Void) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        db.collection("Users").document(uid).getDocument { snapShot, error in
            if let error = error {
                print("Firestoreからユーザの情報を取得できませんでした",error)
                completion(nil,error)
            }
            print("Firestoreからユーザの情報を取得しました")
            guard let data = snapShot?.data() else { return }
            guard let lendPayTaskIdS = data["lendPayTaskId"] as? [String] else { return }

            // 取得したlendPayTaskIdからPayTaskを取得
            self.loadLendPayTask(lendPayTaskIdS: lendPayTaskIdS) { payTasks, error in
                if let error = error {
                    print("lendPayTaskのロード失敗",error)
                }
                completion(payTasks,nil)
            }
        }
    }

    private func loadBorrowPayTask(borrowPayTaskIdS: [String],completion: @escaping([PayTask]?,Error?) -> Void) {
        payTasks = []
        borrowPayTaskIdS.forEach { borrowPayTaskId in
            self.db.collection("PayTasks").document(borrowPayTaskId).getDocument { snapShot, error in
                if let error = error {
                    print("FirestoreからPayTaskの取得に失敗",error)
                    completion(nil,error)
                }
                print("FirestoreからPayTaskの取得に成功")
                guard let data = snapShot?.data() else { return }
                var payTask = PayTask(dic: data)

                guard let lenderUID = data["lenderUID"] as? String else { return }
                guard let isTaskFinished = data["isTaskFinished"] as? Bool else { return }

                // isTaskFinishedがfalseかつlenderUIDがあればpayTasksに追加
                if !isTaskFinished && lenderUID != "" {
                    payTask.lenderUID = lenderUID
                    // ここで名前も代入したいところ
                    self.payTasks.append(payTask)

                    if (self.payTasks.count == borrowPayTaskIdS.count){
                        completion(self.payTasks,nil)
                    }
                }
            }
        }
    }

    private func loadLendPayTask(lendPayTaskIdS: [String], completion: @escaping([PayTask]?,Error?) -> Void) {
        payTasks = []
        lendPayTaskIdS.forEach { lendPayTaskId in
            self.db.collection("PayTasks").document(lendPayTaskId).getDocument { snapShot, error in
                if let error = error {
                    print("FirestoreからPayTaskの取得に失敗",error)
                    completion(nil,error)
                }
                print("FirestoreからPayTaskの取得に成功")
                guard let data = snapShot?.data() else { return }
                var payTask = PayTask(dic: data)

                let lenderUID = data["lenderUID"] as? String
                guard let isTaskFinished = data["isTaskFinished"] as? Bool else { return }

                // isTaskFinishedがfalseかつlenderUIDがあればpayTasksに追加
                if !isTaskFinished && lenderUID != nil {
                    payTask.lenderUID = lenderUID
                    self.payTasks.append(payTask)
                    if (self.payTasks.count == lendPayTaskIdS.count){
                        completion(self.payTasks,nil)
                    }
                }
            }
        }
    }
}

