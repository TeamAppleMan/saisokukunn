//
//  LoanListView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import SwiftUI

struct LoanListView: View {
    let title: String
    let person: String
    let money: Int

    var body: some View {
        HStack {
            // 円形のやつ
            HStack {
                Text("5")
                    .offset(x: 7, y: 0)
                    .font(.title2)
                Text("day")
                    .font(.caption2)
                    .offset(x: 0, y: 5)
            }
            .frame(width: 60, height: 60)
            .foregroundColor(Color.gray)
            .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
            .overlay(RoundedRectangle(cornerRadius: 35).stroke(Color.init(red: 0.90, green: 0.90, blue: 0.90), lineWidth: 5))
            .cornerRadius(35)

            VStack {
                Text(title)
                Text(person)
            }
            Spacer()
            Text("¥ \(money)")
        }
        .frame(height: 70)
        .listRowBackground(Color.clear)
    }
}

//struct LoanListView_Previews: PreviewProvider {
//    static var previews: some View {
//        LoanListView()
//    }
//}
