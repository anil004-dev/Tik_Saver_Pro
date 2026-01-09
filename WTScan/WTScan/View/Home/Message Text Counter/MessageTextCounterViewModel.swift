//
//  MessageTextCounterViewModel.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import Combine
import UIKit

class MessageTextCounterViewModel: ObservableObject {
    
    @Published var messageText: String = ""
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnCopyAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            UIPasteboard.general.string = self.messageText
            WTToastManager.shared.show("Message copied to clipboard")
        }
        
        InterstitialAdManager.shared.showAd()
    }
    
    func btnClearAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.messageText = ""
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
}
