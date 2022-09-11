//
//  User.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/08/23.
//

import Foundation
import Firebase

struct User {
    var userName: String
    var uid: String
    var createdAt: Timestamp
    var token: String
    var borrowPayTaskId: Array<String>
    var lendPayTaskId: Array<String>

    init(dic: [String: Any]){
        self.userName = dic["userName"] as? String ?? ""
        self.uid = dic["uid"] as? String ?? ""
        self.createdAt = dic["createdAt"] as? Timestamp ?? Timestamp()
        self.token = dic["token"] as? String ?? ""
        self.borrowPayTaskId = dic["borrowPayTaskId"] as? Array<String> ?? []
        self.lendPayTaskId = dic["lendPayTaskId"] as? Array<String> ?? []
    }
}
