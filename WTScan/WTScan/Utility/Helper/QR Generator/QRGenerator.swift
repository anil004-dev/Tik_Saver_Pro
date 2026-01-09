//
//  QRGenerator.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import UIKit
import CoreImage.CIFilterBuiltins

class QRGenerator {
    static let shared = QRGenerator()
    
    private let context = CIContext()
    private let filter = CIFilter.qrCodeGenerator()
    
    private init() {}
    
    func generate(from string: String, completion: @escaping (UIImage?) -> Void) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard !string.isEmpty else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let data = Data(string.utf8)
            self.filter.setValue(data, forKey: "inputMessage")
            
            guard let outputImage = self.filter.outputImage else {
                DispatchQueue.main.async {
                    completion(nil)
                }
                return
            }
            
            let scaledImage = outputImage.transformed(by: CGAffineTransform(scaleX: 10, y: 10))
            
            if let cgImage = self.context.createCGImage(scaledImage, from: scaledImage.extent) {
                let qrImage = UIImage(cgImage: cgImage)
                DispatchQueue.main.async {
                    completion(qrImage)
                }
            } else {
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
}
