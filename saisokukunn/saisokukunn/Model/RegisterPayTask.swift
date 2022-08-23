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
}
