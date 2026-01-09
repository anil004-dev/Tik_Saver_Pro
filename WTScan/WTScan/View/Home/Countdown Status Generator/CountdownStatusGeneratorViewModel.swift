//
//  CountdownStatusGeneratorViewModel.swift
//  WTScan
//
//  Created by iMac on 17/11/25.
//

import Combine
import UIKit

class CountdownStatusGeneratorViewModel: ObservableObject {
    
    @Published var eventTitle: String = ""
    @Published var selectedEmoji: String = ""
    @Published var selectedEventDate: Date = .now
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnCopyAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            UIPasteboard.general.string = "\(self.selectedEmoji.isEmpty ? "" : "\(self.selectedEmoji) ")"  + "\(self.getDaysLeft()) " + "days left untill my \(self.eventTitle)"
            WTToastManager.shared.show("Caption copied to clipboard")
        }
        
        InterstitialAdManager.shared.showAd()
    }
    
    func getDaysLeft() -> Int {
        let calendar = Calendar.current
        
        let start = calendar.startOfDay(for: Date())
        let end = calendar.startOfDay(for: selectedEventDate)
        
        let components = calendar.dateComponents([.day], from: start, to: end)
        
        return components.day ?? 0
    }
}
