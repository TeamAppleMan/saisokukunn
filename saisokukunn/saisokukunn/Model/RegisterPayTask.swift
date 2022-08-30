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

    func createPayTaskToFirestore(title: String,money: Int,endTime: Date) async throws {
        guard let lenderUID = Auth.auth().currentUser?.uid else { return }
        let payTask: Dictionary<String, Any> = [
            "title": title,
            "money": money,
            "endTime": endTime,
            "lenderUID": lenderUID,
            "createdAt": Timestamp()
        ]

        let payTaskPath = String(db.collection("PayTasks").document().path.dropFirst(9))
        try await db.collection("PayTasks").document(payTaskPath).setData(payTask)
        try await db.collection("Users").document(lenderUID).updateData(["taskId": FieldValue.arrayUnion([payTaskPath])])
    }

    func fetchQrCode() async throws -> Data {
            try await withCheckedThrowingContinuation { continuation in
                let qrUid = NSUUID().uuidString
                AF.request("https://timelab-api.herokuapp.com/createQrCode/\(qrUid)").response { response in
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

}
