//
//  RegisterPayTask.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/08/23.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import Alamofire

class RegisterPayTask {

    let db = Firestore.firestore()
    var payTaskDocumentPath = String() // createPayTaskToFirestoreとfetchQrCodeで同一のPathを使用
    let loadUser = LoadUser()

    func createPayTaskToFirestore(title: String,money: Int,endTime: Date) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }

        let payTask: Dictionary<String, Any> = [
            "title": title,
            "money": money,
            "endTime": endTime,
            "borrowerUID": uid,
            "createdAt": Timestamp()
        ]
        // PayTaskをFirestoreにセット
        try await db.collection("PayTasks").document(payTaskDocumentPath).setData(payTask)

        // userName(borrow側）をPayTaskに追加
        loadUser.fetchUserName(uid: uid) { userName, error in
            if let error = error {
                print("ユーザ情報の取得に失敗",error)
            }
            guard let userName = userName else { return }
            self.db.collection("PayTasks").document(self.payTaskDocumentPath).setData(["borrowerUserName": userName], merge: true)
        }
        
        // UsersにあるborrowPayTaskIdの更新
        try await db.collection("Users").document(uid).updateData(["borrowPayTaskId": FieldValue.arrayUnion([payTaskDocumentPath])])
    }

    func fetchQrCode() async throws -> Data {
            try await withCheckedThrowingContinuation { continuation in
                AF.request("https://timelab-api.herokuapp.com/createQrCode/\(payTaskDocumentPath)").response { response in
                    switch response.result {
                    case .success(let element):
                        do {
                            let articles: QrCode = try JSONDecoder().decode(QrCode.self, from: response.data as! Data)
                            let imgBase64 = articles.imageBase64
                            let decodeData = Data(base64Encoded: imgBase64)
                            // return
                            continuation.resume(returning: decodeData ?? Data())
                        } catch {
                            print("qrの取得に失敗")
                            continuation.resume(throwing: error)
                        }
                    case .failure(let error):
                        continuation.resume(throwing: error)
                    }
                }
        }
    }

    // lenderUIDをPayTaskのフィールドに追加
    func addLenderUIDToFireStore(payTaskPath: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        try await db.collection("PayTasks").document(payTaskPath).setData(["lenderUID": uid,"isFinished": false], merge: true)

        loadUser.fetchUserName(uid: uid) { userName, error in
            if let error = error {
                print("ユーザ情報の取得に失敗",error)
            }
            guard let userName = userName else { return }
            self.db.collection("PayTasks").document(payTaskPath).setData(["lenderUserName": userName], merge: true)
        }
        // UsersにあるborrowPayTaskIdの更新
        try await db.collection("Users").document(uid).updateData(["lendPayTaskId": FieldValue.arrayUnion([payTaskPath])])
    }

}
