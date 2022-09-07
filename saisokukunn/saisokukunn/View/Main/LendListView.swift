//
//  LendListView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/09/07.
//

import SwiftUI

struct LendListView: View {
    let title: String
    let person: String
    let money: Int
    let limitDay: Int
    @Binding var isPayCompletedAlert: Bool
    @Binding var lendListAlertType: LendListAlertType

    var body: some View {
        HStack {
            // 円形のやつ
            HStack {
                if limitDay < 10 {
                    Text("\(limitDay)")
                        .offset(x: 7, y: 0)
                        .font(.title2)
                    Text("day")
                        .font(.caption2)
                        .offset(x: 0, y: 5)
                } else if limitDay < 100 {
                    Text("\(limitDay)")
                        .font(.system(size: 20))
                        .offset(x: 8, y: 0)
                    Text("day")
                        .font(.system(size: 10))
                        .offset(x: -2, y: 8)
                } else if limitDay < 1000 {
                    Text("\(limitDay)")
                        .font(.system(size: 15))
                        .offset(x: 8, y: 0)
                    Text("day")
                        .font(.system(size: 10))
                        .offset(x: -2, y: 8)
                } else {
                    Text("\(limitDay)")
                        .font(.system(size: 10))
                        .offset(x: 8, y: 0)
                    Text("day")
                        .font(.system(size: 10))
                        .offset(x: -2, y: 8)
                }
            }
            .frame(width: 60, height: 60)
            .foregroundColor(Color.gray)
            .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
            .overlay(RoundedRectangle(cornerRadius: 35).stroke(Color.init(red: 0.85, green: 0.85, blue: 0.85), lineWidth: 5))
            .cornerRadius(35)

            VStack(alignment: .leading) {
                Text(title)
                    .font(.system(.headline, design: .rounded))
                    .bold()
                Text(person)
                    .foregroundColor(.gray)
                    .font(.system(size: 10))
            }

            Spacer()
            Text("¥ \(money)")
                .bold()
                .padding()

            Button(action: {
                isPayCompletedAlert = true
                lendListAlertType = .payCompleted
            }, label: {
                Image(systemName: "x.circle")
            })

        }
        .frame(height: 70)
        .listRowBackground(Color.clear)
    }
}
