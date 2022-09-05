//
//  PKHUDView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/09/05.
//

import SwiftUI
import PKHUD

struct PKHUDView: UIViewRepresentable {
    @Binding var isPresented: Bool
    var HUDContent: HUDContentType
    func makeUIView(context: UIViewRepresentableContext<PKHUDView>) -> UIView {
        return UIView()
    }
    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PKHUDView>) {
        if isPresented {
            HUD.flash(HUDContent, delay: .infinity) { finished in
                isPresented = false
            }
        }
    }
}

struct PKHUDViewModifier<Parent: View>: View {
    @Binding var isPresented: Bool
    var HUDContent: HUDContentType
    var parent: Parent
    var body: some View {
        ZStack {
            parent
            if isPresented {
                PKHUDView(isPresented: $isPresented, HUDContent: HUDContent)
            }
        }
    }
}
