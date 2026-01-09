//
//  QRScannerService.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//


import AVFoundation
import UIKit
import Combine

class QRScannerService: NSObject, ObservableObject, AVCaptureMetadataOutputObjectsDelegate {
    
    private let session = AVCaptureSession()
    private let metadataOutput = AVCaptureMetadataOutput()
    private var isProcessingScan = false

    
    var qrCodeDidScanned: ((String) -> Void)?
    let previewLayer: AVCaptureVideoPreviewLayer
    
    override init() {
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        super.init()
        configureSession()
    }
    
    private func configureSession() {
        guard let device = AVCaptureDevice.default(for: .video),
              let input = try? AVCaptureDeviceInput(device: device) else { return }
        
        if session.canAddInput(input) { session.addInput(input) }
        if session.canAddOutput(metadataOutput) {
            session.addOutput(metadataOutput)
            metadataOutput.setMetadataObjectsDelegate(self, queue: .main)
        }
        
        previewLayer.videoGravity = .resizeAspectFill
    }
    
    func startRunning() {
        isProcessingScan = false
        guard !session.isRunning else { return }
        
        DispatchQueue.global().async {
            self.session.startRunning()

            DispatchQueue.main.async {
                // Must be set AFTER session starts
                self.metadataOutput.metadataObjectTypes = [.qr]
            }
        }
    }
    
    func stopRunning() {
        guard session.isRunning else { return }
        DispatchQueue.global().async {
            self.session.stopRunning()
        }
    }
    
    // REQUIRED DELEGATE METHOD
    func metadataOutput(
        _ output: AVCaptureMetadataOutput,
        didOutput metadataObjects: [AVMetadataObject],
        from connection: AVCaptureConnection
    ) {
        guard !isProcessingScan else { return }
        isProcessingScan = true
        
        guard let obj = metadataObjects.first as? AVMetadataMachineReadableCodeObject,
              let qrText = obj.stringValue, !qrText.isEmpty else {
            isProcessingScan = false
            return
        }
        
        
        stopRunning()
            
        DispatchQueue.main.async {
            self.qrCodeDidScanned?(qrText)
        }
    }
}
