//
//  WTSafariView.swift
//  WTScan
//
//  Created by iMac on 26/11/25.
//


import UIKit
import SwiftUI
import SafariServices

struct WTSafariView: UIViewControllerRepresentable {
    
    let url: URL

    func makeUIViewController(context: UIViewControllerRepresentableContext<Self>) -> SFSafariViewController {
        return SFSafariViewController(url: url)
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: UIViewControllerRepresentableContext<WTSafariView>) {
    }
}
