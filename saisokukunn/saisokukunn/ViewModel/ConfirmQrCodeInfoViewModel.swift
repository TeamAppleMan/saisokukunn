//
//  ConfirmQrCodeInfoViewModel.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/09/11.
//

import Foundation
import SwiftUI

class ConfirmQrCodeInfoViewModel: ObservableObject {
   @Published var registerPayTask = RegisterPayTask()

    func addLenderUIDToFireStore(documentPath: String) async throws {
        try await registerPayTask.addLenderUIDToFireStore(payTaskPath: documentPath)
    }
}
