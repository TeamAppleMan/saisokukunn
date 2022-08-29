//
//  QrCodeScannerView.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/22.
//

/*
 QrScannerのライブラリが、Storyboardでしか使えなかったので、SwiftUIとStoryboardを共存させるコード。
 このフォルダが暗黙的に介されてStoryboard（QrCodeScannerViewController）が開かれる
 */

import SwiftUI

struct ThrowQrCodeScannerViewController: View {
    var body: some View {
        QrCodeScannerViewControllerWrapper {
            Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
        }.ignoresSafeArea()
    }
}

struct QrCodeScannerViewControllerWrapper<Content: View>: UIViewControllerRepresentable {

    typealias UIViewControllerType = QrCodeScannerViewController
    var content: () -> Content

    func makeUIViewController(context: Context) -> QrCodeScannerViewController {
        let viewControllerWithStoryboard = QrCodeScannerViewController()
        return viewControllerWithStoryboard
    }

    func updateUIViewController(_ uiviewController: QrCodeScannerViewController, context: Context) {
    }

}
