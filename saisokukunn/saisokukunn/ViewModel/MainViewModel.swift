//
//  MainViewModel.swift
//  saisokukunn
//
//  Created by 近藤米功 on 2022/09/11.
//

import Foundation
import SwiftUI

class MainViewModel: ObservableObject {

    @Published var registerUser = RegisterUser()
    @Published var registerPayTask = RegisterPayTask()
    @Published var loadPayTask = LoadPayTask()
    @Published var lendPayTaskList = [PayTask]()
    @Published var borrowPayTaskList = [PayTask]()

    @Published var totalLendingMoney = Int()
    @Published var totalBorrowingMoney = Int()

    func signOut() async throws {
        try await registerUser.signOut()
    }

    func updateIsFinishedPayTask(selectedIndex: Int) async throws {
        try await registerPayTask.updateIsFinishedPayTask(documentPath: lendPayTaskList[selectedIndex].documentPath)
    }

    func fetchBorrowPayTask() {
        loadPayTask.fetchBorrowPayTask { lendPayTasks, error in
            if let error = error {
                print("Firestoreから貸し手のPayTaskの取得に失敗",error)
            }
            guard let lendPayTasks = lendPayTasks else { return }
            self.lendPayTaskList = self.sortPayTasks(paytasks: lendPayTasks)
            // 貸している合計金額の表示
            lendPayTasks.forEach { lendPayTask in
                self.totalLendingMoney = lendPayTask.money
            }
        }
    }

    func fetchLenderPayTask() {
        loadPayTask.fetchLenderPayTask { borrowPayTasks, error in
            if let error = error {
                print("Firestoreから借り手のPayTaskの取得に失敗",error)
            }
            guard let borrowPayTasks = borrowPayTasks else { return }
            self.borrowPayTaskList = self.sortPayTasks(paytasks: borrowPayTasks)
            // 借りている合計金額の表示
            borrowPayTasks.forEach { borrowPayTask in
                self.totalBorrowingMoney = borrowPayTask.money
            }
        }

    }

    // 締切日が近い順にソート
    private func sortPayTasks(paytasks: [PayTask]) -> [PayTask] {

        var tasks = [PayTask]()
        let aaa = paytasks.sorted(by: { (a, b) -> Bool in
            return a.endTime.dateValue() < b.endTime.dateValue()
        })
        for data in aaa {
            tasks.append(data)
        }
        return tasks
    }
}
