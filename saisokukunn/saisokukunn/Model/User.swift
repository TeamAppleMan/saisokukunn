//
//  User.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/08/23.
//

import Foundation
import Firebase

struct User {
    public var id = UUID().uuidString
    var userName: String
    var uid: String
    var createdAt: Timestamp
    var taskId: Array<String>

    init(dic: [String: Any]){
        self.userName = dic["userName"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.taskId = dic["taskID"] as? Array<String> ?? []
    }
}
