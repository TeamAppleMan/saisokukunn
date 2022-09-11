//
//  ConfirmLendInfoViewModel.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/09/11.
//

import Foundation
import SwiftUI

class ConfirmLendInfoViewModel: ObservableObject {
    @Published var registerPayTask = RegisterPayTask()
    @Published var qrDecodedData = Data()

    func fetchQrCode() async throws {
        self.qrDecodedData = try await registerPayTask.fetchQrCode()
    }

    func createPayTaskToFirestore(title: String, money: Int,endTime: Date) async throws {
        try await registerPayTask.createPayTaskToFirestore(title: title, money: money, endTime: endTime)
    }
}
