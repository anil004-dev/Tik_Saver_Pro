//
//  TikSaveShareSheet.swift
//  WTScan
//
//  Created by Anil Jadav on 12/01/26.
//

import UIKit
import SwiftUI

struct TikSaveShareSheet: UIViewControllerRepresentable {
    let items: [Any]

    func makeUIViewController(context: Context) -> UIActivityViewController {
        UIActivityViewController(activityItems: items, applicationActivities: nil)
    }

    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {}
}
