//
//  saisokukunnApp.swift
//  saisokukunn
//
//  Created by 濵田　悠樹 on 2022/08/20.
//

import SwiftUI

@main
struct saisokukunnApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            SignUpView()
        }
    }
}
