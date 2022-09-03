//
//  PayTask.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/08/23.
//

import Foundation
import Firebase

struct PayTask {
    let title: String
    let money: Int
    let endTime: Timestamp
    let borrowerUID: String
    let createdAt: Timestamp

    var lenderUID: String?
    var lenderUserName: String?
    var isFinished: Bool?
    var borrowerUserName: String?

    init(dic: [String: Any]) {
        self.title = dic["title"] as? String ?? ""
        self.money = dic["money"] as? Int ?? 0
        self.endTime = dic["endTime"] as? Timestamp ?? Timestamp()
        self.borrowerUID = dic["borrowerUID"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
