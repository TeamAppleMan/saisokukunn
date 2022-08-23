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
    let number = 50

    var body: some View {
        HStack {
            // 円形のやつ
            HStack {
                if number < 10 {
                    Text("\(number)")
                        .offset(x: 7, y: 0)
                        .font(.title2)
                    Text("day")
                        .font(.caption2)
                        .offset(x: 0, y: 5)
                } else if number < 100 {
                    Text("\(number)")
                        .font(.system(size: 20))
                        .offset(x: 8, y: 0)
                    Text("day")
                        .font(.system(size: 10))
                        .offset(x: -2, y: 8)
                } else if number < 1000 {
                    Text("\(number)")
                        .font(.system(size: 15))
                        .offset(x: 8, y: 0)
                    Text("day")
                        .font(.system(size: 10))
                        .offset(x: -2, y: 8)
                } else {
                    Text("\(number)")
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

            VStack {
                Text(title)
                    .font(.headline)
                HStack {
                    Text(person)
                        .padding(.leading, 20.0)
                }
            }

            Spacer()
            Text("¥ \(money)")
                .padding()
        }
        .frame(height: 70)
        .listRowBackground(Color.clear)
    }
}

struct LoanListView_Previews: PreviewProvider {
    static var previews: some View {
        LoanListView(title: "zzz", person: "石原", money: 5000)
    }
}
