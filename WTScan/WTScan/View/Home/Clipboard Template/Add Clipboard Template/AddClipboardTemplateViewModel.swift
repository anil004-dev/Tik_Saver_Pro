//
//  AddClipboardTemplateViewModel.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import Combine
import UIKit

class AddClipboardTemplateViewModel: ObservableObject {
    
    @Published var cliboardText: String = ""
    
    var didTempCreated: (() -> Void)?
    var dismiss: (() -> Void)?
    
    func btnBackAction() {
        dismiss?()
    }
    
    func btnPasteAction() {
        if let copidText = UIPasteboard.general.string {
            InterstitialAdManager.shared.didFinishedAd = { [weak self] in
                guard let self = self else { return }
                InterstitialAdManager.shared.didFinishedAd = nil
                
                self.cliboardText = copidText
            }
            
            InterstitialAdManager.shared.increaseTapCount()
        }
    }
    
    func btnSaveTemplate() {
        let cliboardText = cliboardText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !cliboardText.isEmpty else {
            return
        }
        
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            ClipboardManager.shared.addClipboard(clipboardText: cliboardText) { [weak self] _, _ in
                self?.didTempCreated?()
            }
        }
        
        InterstitialAdManager.shared.showAd()
    }
}
