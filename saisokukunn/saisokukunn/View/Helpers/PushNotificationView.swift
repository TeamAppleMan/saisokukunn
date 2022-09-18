//
//  PushNotificationView.swift
//  saisokukunn
//
//  Created by 濵田　悠樹 on 2022/09/11.
//

import SwiftUI

struct PushNotificationView: View {
    @State var pushNotificationResult = ""
    @State var isWatingAPI = false
    
    @State var user_fcm_token = "evdmWF-M2EdeoOG0hWU4JB:APA91bHDO-BJ8lt6c1O02qJ0jfHZyD_WSWks_dJP3m75PoQ-d8rMhQ9q4fE6c0hhGg6e1-HjCGB20AN07G4rToCziDuUFQmqH5bc3zAVm7hdCWW-nnh_63rEjnyBxSmR0UKaKfcb6yqZ"
    @State var title = "お好み焼き"
    @State var content = "¥1,000"
    
    var body: some View {
        VStack {
            
            if isWatingAPI {
                ProgressView()
            } else {
                Text(pushNotificationResult)
                    .fontWeight(.bold)
                
                Spacer()
                    .frame(height: 50)
                
                Button(action: {
                    Task {
                        let response = try await PushNotification().fetchNews(user_fcm_token: user_fcm_token, title: title, body: content)
                        print(response)
                        if response.result == "success" {
                            pushNotificationResult = "Push通知 成功しました"
                        } else {
                            pushNotificationResult = "Push通知 エラーが発生しました"
                        }
                    }
                }) {
                    Text("Push通知")
                        .padding()
                        .foregroundColor(.white)
                        .background(.orange)
                        .cornerRadius(10)
                }
            }
        }
    }
    
    /*
    // TODO: Modelに分ける
    func pushNotificationAPI() async throws -> String {
        // GET
        isWatingAPI = true
        print(#function)
        // TODO: APIをクラウドサーバーたてる
        let url = URL(string: "http://127.0.0.1:8000/PushNotification/")!
        var request = URLRequest(url: url)
        // TODO: FCMトークン, title, body を POSTで送れるよう
        request.httpMethod = "GET"
        let (data, _) = try await URLSession.shared.data(for: request)
        let decoder = JSONDecoder()
        let hoge = try await decoder.decode(Hoge.self, from: data)
        print(hoge.result)
        isWatingAPI = false
        return hoge.result
    }
     */
}



struct PushNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        PushNotificationView()
    }
}

