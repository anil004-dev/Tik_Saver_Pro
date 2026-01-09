//
//  QRScanResultViewModel.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import Combine

class QRScanResultViewModel: ObservableObject {
    
    let qrText: String
    @Published var showShareSheetView: Bool = false
    
    init(qrText: String) {
        self.qrText = qrText
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func openShareSheetView() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.showShareSheetView = true
        }
        
        InterstitialAdManager.shared.showAd()
    }
}
