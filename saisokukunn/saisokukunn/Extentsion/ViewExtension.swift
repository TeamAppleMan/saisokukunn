//
//  ViewExtension.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

import Foundation
import SwiftUI
import PKHUD

extension View {

    func cornerRadius(_ radius: CGFloat, maskedCorners: CACornerMask) -> some View {
        self.modifier(PartlyRoundedCornerModifier(cornerRadius: radius,
                                                  maskedCorners: maskedCorners))
    }

    public func PKHUD(isPresented: Binding<Bool>, HUDContent: HUDContentType, delay: Double) -> some View {
        PKHUDViewModifier(isPresented: isPresented, HUDContent: HUDContent, delay: delay, parent: self)
    }

}

struct PartlyRoundedCornerView: UIViewRepresentable {
    let cornerRadius: CGFloat
    let maskedCorners: CACornerMask

    func makeUIView(context: UIViewRepresentableContext<PartlyRoundedCornerView>) -> UIView {
        let uiView = UIView()
        uiView.layer.cornerRadius = cornerRadius
        uiView.layer.maskedCorners = maskedCorners
        uiView.backgroundColor = .white
        return uiView
    }

    func updateUIView(_ uiView: UIView, context: UIViewRepresentableContext<PartlyRoundedCornerView>) {
    }
}


struct PartlyRoundedCornerModifier: ViewModifier {
    let cornerRadius: CGFloat
    let maskedCorners: CACornerMask

    func body(content: Content) -> some View {
        content.mask(PartlyRoundedCornerView(cornerRadius: self.cornerRadius,
                                             maskedCorners: self.maskedCorners))
    }
}
