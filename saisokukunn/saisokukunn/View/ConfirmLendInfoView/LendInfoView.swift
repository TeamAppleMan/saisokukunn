//
//  LendInfoView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/28.
//

import SwiftUI

struct LendInfoView: View {

    var body: some View {
        let titleTextColor = Color.init(red: 0.3, green: 0.3, blue: 0.3)

        ZStack {
            RoundedRectangle(cornerRadius: 10, style: .continuous)
                .foregroundColor(.white)
                .shadow(color: .gray, radius: 10)

            VStack(alignment: .leading) {
                VStack(alignment: .leading, spacing: 5) {
                    Text("タイトル")
                        .foregroundColor(.gray)
                    // 文字数ごとにサイズを変更させる
                    Text("お好み焼き代")
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
                    Text("¥ 5500")
                        .foregroundColor(titleTextColor)
                        .font(.title2)
                        .bold()
                }.padding(.top)

                Divider()

                VStack(alignment: .leading, spacing: 5) {
                    Text("締め切り")
                        .foregroundColor(.gray)
                    HStack(alignment: .bottom) {
                        Text("2022")
                            .foregroundColor(titleTextColor)
                            .font(.title2)
                            .bold()
                        Text("年")
                            .foregroundColor(titleTextColor)

                        Text("2")
                            .foregroundColor(titleTextColor)
                            .font(.title2)
                            .bold()
                        Text("月")
                            .foregroundColor(titleTextColor)

                        Text("11")
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

struct LendInfoView_Previews: PreviewProvider {
    static var previews: some View {
        LendInfoView()
    }
}
