//
//  PushNotificationView.swift
//  saisokukunn
//
//  Created by 濵田　悠樹 on 2022/09/11.
//

import SwiftUI

// HTTP通信のレスポンス
struct Hoge: Codable {
    var id: Int
    var result: String
    
    init(id: Int, result: String) {
        self.id = id
        self.result = result
    }
}

struct PushNotificationView: View {
    @State var pushNotificationResult = ""
    @State var isWatingAPI = false
    
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
                        let result = try await pushNotificationAPI()
                        if result == "success" {
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
}



struct PushNotificationView_Previews: PreviewProvider {
    static var previews: some View {
        PushNotificationView()
    }
}

