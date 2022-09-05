//
//  QrCodeScannerViewController.swift
//  saisokukunn
//
//  Created by 前田航汰 on 2022/08/29.
//

import UIKit
import SwiftUI
import QRScanner
import AVFoundation

class QrCodeScannerViewController: UIViewController {

    @IBOutlet var qrScannerView: QRScannerView!
    @IBOutlet var flashButton: FlashButton!

    let loadPayTask = LoadPayTask()

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setupQRScanner()
    }

    private func setupQRScanner() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            setupQRScannerView()
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                if granted {
                    DispatchQueue.main.async { [weak self] in
                        self?.setupQRScannerView()
                    }
                }
            }
        default:
            showAlert()
        }
    }

    private func setupQRScannerView() {
        qrScannerView.configure(delegate: self, input: .init(isBlurEffectEnabled: true))
        qrScannerView.startRunning()
    }

    private func showAlert() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            let alert = UIAlertController(title: "エラー", message: "本アプリは設定からカメラアクセスを許可にする必要があります。", preferredStyle: .alert)
            alert.addAction(.init(title: "確認", style: .default))
            self?.present(alert, animated: true)
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        qrScannerView.rescan()
        qrScannerView.stopRunning()
    }

    // MARK: - Actions
    @IBAction func tapFlashButton(_ sender: UIButton) {
        qrScannerView.setTorchActive(isOn: !sender.isSelected)
    }
}

// MARK: - QRScannerViewDelegate
extension QrCodeScannerViewController: QRScannerViewDelegate {
    func qrScannerView(_ qrScannerView: QRScannerView, didFailure error: QRScannerError) {
        print(error.localizedDescription)
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didSuccess code: String)  {
        // code（= documentPath)を元にFirestoreからPayTaskを取得
        loadPayTask.fetchPayTask(documentPath: code) { payTask, error in
            if let error = error {
                print("PayTaskの取得に失敗",error)
            }
            guard let payTask = payTask else { return }

            // 取得したPayTaskの送信
            let view = UIHostingController(rootView: ConfirmQrCodeInfoView(title: payTask.title, lendPerson: payTask.borrowerUserName ?? "", money: String(payTask.money), endTime: payTask.endTime.dateValue(),documentPath: code))
            self.navigationController?.pushViewController(view, animated: true)
            qrScannerView.stopRunning()
        }
    }

    func qrScannerView(_ qrScannerView: QRScannerView, didChangeTorchActive isOn: Bool) {
        flashButton.isSelected = isOn
    }
}

// MARK: - Private
private extension QrCodeScannerViewController {
    func openWeb(url: URL) {
        UIApplication.shared.open(url, options: [:], completionHandler: { [weak self] _ in
            self?.qrScannerView.rescan()
        })
    }

    func showAlert(code: String) {
        let alertController = UIAlertController(title: code, message: nil, preferredStyle: .actionSheet)
        let copyAction = UIAlertAction(title: "Copy", style: .default) { [weak self] _ in
            UIPasteboard.general.string = code
            self?.qrScannerView.rescan()
        }
        alertController.addAction(copyAction)
        let searchWebAction = UIAlertAction(title: "Search Web", style: .default) { [weak self] _ in
            UIApplication.shared.open(URL(string: "https://www.google.com/search?q=\(code)")!, options: [:], completionHandler: nil)
            self?.qrScannerView.rescan()
        }
        alertController.addAction(searchWebAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: { [weak self] _ in
            self?.qrScannerView.rescan()
        })
        alertController.addAction(cancelAction)
        present(alertController, animated: true, completion: nil)
    }
}


final class FlashButton: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        settings()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        settings()
    }

    override var isSelected: Bool {
        didSet {
            let color: UIColor = isSelected ? .gray : .lightGray
            backgroundColor = color.withAlphaComponent(0.7)
        }
    }
}

private extension FlashButton {
    func settings() {
        setTitleColor(.darkGray, for: .normal)
        setTitleColor(.white, for: .selected)
        setTitle("OFF", for: .normal)
        setTitle("ON", for: .selected)
        tintColor = .clear
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        layer.cornerRadius = frame.size.width / 2
        isSelected = false
    }
}

