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
                        .font(.caption)
                        .foregroundColor(.gray)
                    // 文字数ごとにサイズを変更させる
                    Text(title)
                        .font(.callout)
                        .foregroundColor(titleTextColor)
                        .bold()
                }

                Divider()

                VStack(alignment: .leading, spacing: 5) {
                    Text("金額")
                        .font(.caption)
                        .foregroundColor(.gray)
                    Text("¥ \(money)")
                        .font(.callout)
                        .foregroundColor(titleTextColor)
                        .bold()
                }.padding(.top)

                Divider()

                VStack(alignment: .leading, spacing: 5) {
                    Text("締め切り")
                        .font(.caption)
                        .foregroundColor(.gray)
                    HStack(alignment: .bottom) {
                        Text(dateToString.year())
                            .font(.callout)
                            .foregroundColor(titleTextColor)
                            .bold()
                        Text("年")
                            .font(.caption)
                            .foregroundColor(titleTextColor)

                        Text(dateToString.month())
                            .font(.callout)
                            .foregroundColor(titleTextColor)
                            .bold()
                        Text("月")
                            .font(.caption)
                            .foregroundColor(titleTextColor)

                        Text(dateToString.day())
                            .font(.callout)
                            .foregroundColor(titleTextColor)
                            .bold()
                        Text("日")
                            .font(.caption)
                            .foregroundColor(titleTextColor)
                    }
                }.padding(.top)
            }
            .lineLimit(1)
            .minimumScaleFactor(0.1)
            .padding()
        }
    }
}

//
//struct LendInfoView_Previews: PreviewProvider {
//    static var previews: some View {
//        LendInfoView()
//    }
//}
