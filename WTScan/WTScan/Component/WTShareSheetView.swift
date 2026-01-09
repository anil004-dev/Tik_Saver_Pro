//
//  WTShareSheetView.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import SwiftUI
import UIKit

struct WTShareSheetView: UIViewControllerRepresentable {
    var items: [Any]
    var applicationActivities: [UIActivity]? = nil
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<WTShareSheetView>) -> UIActivityViewController {
        let controller = UIActivityViewController(activityItems: items, applicationActivities: applicationActivities)
        controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
            self.presentationMode.wrappedValue.dismiss()
        }
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: UIViewControllerRepresentableContext<WTShareSheetView>) {}
}

