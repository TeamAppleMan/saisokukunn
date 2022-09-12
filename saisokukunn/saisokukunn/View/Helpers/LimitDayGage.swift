//
//  LimitDayGage.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/09/12.
//
/*
 MainViewのList内左側の「○day」部分のView。
 色の設定は４色で以下にした。
 〜3日前...灰色
 3日前〜3日前...超うすピンク
 3日前〜1日前...ピンク
 当日〜...赤

 */

import SwiftUI

struct LimitDayGage: View {
    @State var limitDay: Int
    @State var allDay: Int
    @State var valueStartRatio: CGFloat = 0
    @State var valueRatio: CGFloat

    let pieRedBackGroundColorLv1 = Color.init(red: 1.0, green: 0.90, blue: 0.90)
    let pieRedBackGroundColorLv2 = Color.init(red: 1.0, green: 0.70, blue: 0.70)
    let pieRedBackGroundColorLv3 = Color.init(red: 1.0, green: 0.40, blue: 0.40)

    let grayTextColor = Color.gray
    let grayBackgroundColor = Color.init(red: 0.95, green: 0.95, blue: 0.95)

    var body: some View {

        ZStack {

            PieProgressView(value: valueStartRatio)
                .frame(width: 65, height: 65)
                .onAppear {
                    withAnimation(.linear(duration: 1.5)) {
                        print(limitDay)
                        print(allDay)
                        print(CGFloat(limitDay)/CGFloat(allDay))
                        print(valueRatio)
                        self.valueStartRatio = valueRatio
                    }
                }


            if limitDay <= 0 {
                HStack {
                    Text("\(limitDay)")
                        .offset(x: 7, y: 0)
                        .font(.title2)
                    Text("day")
                        .font(.caption2)
                        .offset(x: 0, y: 5)
                }
                .frame(width: 60, height: 60)
                .foregroundColor(Color.white)
                .background(pieRedBackGroundColorLv3)
                .cornerRadius(35)
            } else if limitDay <= 3 {
                HStack {
                    Text("\(limitDay)")
                        .offset(x: 7, y: 0)
                        .font(.title2)
                    Text("day")
                        .font(.caption2)
                        .offset(x: 0, y: 5)
                }
                .frame(width: 60, height: 60)
                .foregroundColor(Color.white)
                .background(pieRedBackGroundColorLv2)
                .cornerRadius(35)
            } else if limitDay <= 5 {
                HStack {
                    Text("\(limitDay)")
                        .offset(x: 7, y: 0)
                        .font(.title2)
                    Text("day")
                        .font(.caption2)
                        .offset(x: 0, y: 5)
                }
                .frame(width: 60, height: 60)
                .foregroundColor(Color.gray)
                .background(pieRedBackGroundColorLv1)
                .cornerRadius(35)

            } else if limitDay < 10 {
                HStack {
                    Text("\(limitDay)")
                        .offset(x: 7, y: 0)
                        .font(.title2)
                    Text("day")
                        .font(.caption2)
                        .offset(x: 0, y: 5)
                }
                .frame(width: 60, height: 60)
                .foregroundColor(Color.gray)
                .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                .cornerRadius(35)
            } else if limitDay < 100 {
                HStack {
                    Text("\(limitDay)")
                        .font(.system(size: 20))
                        .offset(x: 8, y: 0)
                    Text("day")
                        .font(.system(size: 10))
                        .offset(x: -2, y: 8)
                }
                .frame(width: 60, height: 60)
                .foregroundColor(Color.gray)
                .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                .cornerRadius(35)
            } else if limitDay < 1000 {
                HStack {
                    Text("\(limitDay)")
                        .font(.system(size: 15))
                        .offset(x: 8, y: 0)
                    Text("day")
                        .font(.system(size: 10))
                        .offset(x: -2, y: 8)
                }
                .frame(width: 60, height: 60)
                .foregroundColor(Color.gray)
                .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                .cornerRadius(35)
            } else {
                HStack {
                    Text("\(limitDay)")
                        .font(.system(size: 10))
                        .offset(x: 8, y: 0)
                    Text("day")
                        .font(.system(size: 10))
                        .offset(x: -2, y: 8)
                }
                .frame(width: 60, height: 60)
                .foregroundColor(Color.gray)
                .background(Color.init(red: 0.95, green: 0.95, blue: 0.95))
                .cornerRadius(35)
            }
        }
    }
}

struct PieProgressView: View {
    let value: CGFloat

    var body: some View {

        ZStack {
            Circle()
                .fill(Color.black.opacity(0.08))
            PieShape(value: value)
                .fill(.gray)
                .rotationEffect(.degrees(-90))
        }

    }
}

struct PieShape: Shape {

    var value: CGFloat

    var animatableData: CGFloat {
        get { value }
        set { value = newValue }
    }

    func path(in rect: CGRect) -> Path {
        Path { path in
            let center = CGPoint(x: rect.midX, y: rect.midY)
            path.move(to: center)
            path.addArc(
                center: center,
                radius: rect.width / 2,
                startAngle: .degrees(0),
                endAngle: .degrees(Double(360 * value)),
                clockwise: false
            )
            path.closeSubpath()
        }
    }
}

//struct LimitDayGage_Previews: PreviewProvider {
//    static var previews: some View {
//        LimitDayGage(limitDay: 3, value: 0.8)
//    }
//}
