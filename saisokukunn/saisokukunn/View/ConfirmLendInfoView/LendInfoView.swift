//
//  LendInfoView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/28.
//

import SwiftUI
import Foundation

struct LendInfoView: View {
    let title: String
    let money: String
    let endTime: Date

    var body: some View {
        let titleTextColor = Color.init(red: 0.3, green: 0.3, blue: 0.3)

        // TODO: Modelの繋がっている。切り離したい。
        let dateToString = DateToString(date: endTime)

        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 10)

            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("タイトル")
                        .foregroundColor(.gray)
                    // 文字数ごとにサイズを変更させる
                    Text(title)
                        .foregroundColor(titleTextColor)
                        .font(.title2)
                        .bold()
                        .lineLimit(2)
                        .minimumScaleFactor(0.1)
                }

                Divider()

                VStack(alignment: .leading, spacing: 5) {
                    Text("金額")
                        .foregroundColor(.gray)
                    Text("¥ \(money)")
                        .foregroundColor(titleTextColor)
                        .font(.title2)
                        .bold()
                }.padding(.top)

                Divider()

                VStack(alignment: .leading, spacing: 5) {
                    Text("締め切り")
                        .foregroundColor(.gray)
                    HStack(alignment: .bottom) {
                        Text(dateToString.year())
                            .foregroundColor(titleTextColor)
                            .font(.title2)
                            .bold()
                        Text("年")
                            .foregroundColor(titleTextColor)

                        Text(dateToString.month())
                            .foregroundColor(titleTextColor)
                            .font(.title2)
                            .bold()
                        Text("月")
                            .foregroundColor(titleTextColor)

                        Text(dateToString.day())
                            .foregroundColor(titleTextColor)
                            .font(.title2)
                            .bold()
                        Text("日")
                            .foregroundColor(titleTextColor)
                    }
                }.padding(.top)
            }.padding()
        }
    }
}

//
//struct LendInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        LendInfoView()
//    }
//}
