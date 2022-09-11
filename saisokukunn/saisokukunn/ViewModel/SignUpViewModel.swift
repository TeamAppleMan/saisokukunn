//
//  SignUpViewModel.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/09/11.
//

import Foundation
import SwiftUI

class SignUpViewModel: ObservableObject {
    @Published var registerUser = RegisterUser()

    func signIn(userName: String) async throws {
        try await registerUser.signIn(userName: userName)
    }

}
