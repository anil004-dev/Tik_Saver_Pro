//
//  QRScannerViewModel.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import Combine
import SwiftUI
import AVFoundation

class QRScannerViewModel: ObservableObject {
    
    @Published var scanner = QRScannerService()
    @Published var scannedResult: String = ""
    
    func onAppear() {
        Utility.requestCameraPermission { [weak self] isGranted in
            guard let self = self, isGranted else { return }
            self.scanner.startRunning()
            self.scanner.qrCodeDidScanned = { [weak self] qrText in
                guard let self = self else { return }
                self.openQRScanResultView(qrText: qrText)
            }
        }
    }
    
    func onDisappear() {
        scanner.qrCodeDidScanned = nil
        scanner.stopRunning()
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func openQRScanResultView(qrText: String) {
        NavigationManager.shared.push(to: .qrScanResult(qrText: qrText))
    }
}
