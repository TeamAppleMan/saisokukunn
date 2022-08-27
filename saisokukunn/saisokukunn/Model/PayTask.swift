//
//  PayTask.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/08/23.
//

import Foundation
import Firebase

struct PayTask {
    var title: String
    var money: Int
    var endDate: Date
    var lenderUID: String
    var createdAt: Timestamp

    init(dic: [String: Any]) {
        self.title = dic["title"] as? String ?? ""
        self.money = dic["money"] as? Int ?? 0
        self.endDate = dic["endDate"] as? Date ?? Date()
        self.lenderUID = dic["lenderUID"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
    }
}
