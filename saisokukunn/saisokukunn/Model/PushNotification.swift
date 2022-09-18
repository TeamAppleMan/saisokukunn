//
//  PushNotification.swift
//  saisokukunn
//
//  Created by 濵田　悠樹 on 2022/09/15.
//

import Foundation
import Alamofire

class PushNotification {
    
    // POST
    public func fetchNews(user_fcm_token: String, title: String, body: String) async throws -> PushNotificationResponse {
        
        let url = "https://fcm-push-notification-mobile.herokuapp.com/pushNotification/"
        let headers: HTTPHeaders = [
            "Contenttype": "application/json"
        ]
        let parameters:[String: Any] = [
            "user_fcm_token": user_fcm_token,
            "title": title,
            "body": body,
        ]
        return try await AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default, headers: headers)
            .serializingDecodable(PushNotificationResponse.self)
            .value
    }
    
    // GET
    /*
     public func fetchNews(user_fcm_token: String, title: String, body: String) async throws -> PushNotificationResponse {
         print(#function)
         let url = URL(string: "http://127.0.0.1:8000/get")!
         var request = URLRequest(url: url)
         request.httpMethod = "GET"
         let (data, _) = try await URLSession.shared.data(for: request)
         let decoder = JSONDecoder()
         let response = try await decoder.decode(PushNotificationResponse.self, from: data)
         return response
     }
     */
}
