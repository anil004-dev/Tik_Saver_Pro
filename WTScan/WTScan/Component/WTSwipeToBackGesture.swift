//
//  WTSwipeToBackGesture.swift
//  WTScan
//
//  Created by iMac on 12/11/25.
//


import SwiftUI

struct WTSwipeToBackGesture: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            if let navigationController = controller.navigationController {
                navigationController.interactivePopGestureRecognizer?.isEnabled = true
                navigationController.interactivePopGestureRecognizer?.delegate = nil
            }
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
