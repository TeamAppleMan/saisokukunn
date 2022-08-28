//
//  ShadowButtonView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/23.
//

import SwiftUI

struct ShadowButtonView: View {
    @Binding var isPressed: Bool
    var displayName: String?
    var systemImageName: String?

    var body: some View {
        Button(action: {
            isPressed.toggle()
            print("tap buton")
        }) {
            HStack {
                if displayName == nil && systemImageName == nil {
                    Text("  ")
                } else if displayName == nil && systemImageName != nil {
                    Image(systemName: systemImageName!)
                } else if displayName != nil && systemImageName == nil {
                    Text(displayName!)
                        .font(.callout)
                } else {
                    Text(displayName!)
                        .font(.callout)
                    Image(systemName: systemImageName!)
                }
            }
        }
        .padding()
        .accentColor(Color.black)
        .background(Color.white)
        .cornerRadius(25)
        .shadow(color: Color.white, radius: 10, x: 0, y: 3)
        .scaleEffect(isPressed ? 0.9 : 1.0)
        .animation(.easeOut(duration: 1.0), value: isPressed)
        .padding()
    }
}

//struct ShadowButtonView_Previews: PreviewProvider {
//    static var previews: some View {
//        ShadowButtonView()
//    }
//}
