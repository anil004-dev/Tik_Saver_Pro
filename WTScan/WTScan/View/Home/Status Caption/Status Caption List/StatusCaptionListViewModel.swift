//
//  StatusCaptionListViewModel.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import Combine
import UIKit

class StatusCaptionListViewModel: ObservableObject {
    
    @Published var captionCategory: WTCaptionCategory
    
    init(captionCategory: WTCaptionCategory) {
        self.captionCategory = captionCategory
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnCopyAction(caption: WTCaptionItem) {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let _ = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            UIPasteboard.general.string = caption.text
            WTToastManager.shared.show("Caption copied to clipboard")
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
}
