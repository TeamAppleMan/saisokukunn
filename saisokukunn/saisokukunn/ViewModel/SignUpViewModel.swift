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

    func signIn(userName: String,email: String,password: String) async throws -> Bool {
        try await registerUser.signIn(userName: userName,email: email,password: password)
    }

    func validateEmail(candidate: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        return NSPredicate(format: "SELF MATCHES %@", emailRegex).evaluate(with: candidate)
    }

    func validatePassword(candidate: String) -> Bool {
        let password = candidate.trimmingCharacters(in: .whitespaces)
        if password.count < 6 {
            return false
        } else {
            return true
        }
    }

}
