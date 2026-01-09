//
//  WTCameraPreview.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import SwiftUI
import AVFoundation

struct WTCameraPreview: UIViewRepresentable {
    let layer: AVCaptureVideoPreviewLayer

    func makeUIView(context: Context) -> UIView {
        let view = UIView()
        layer.videoGravity = .resizeAspectFill
        view.layer.addSublayer(layer)
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            layer.frame = uiView.bounds
        }
    }
}
