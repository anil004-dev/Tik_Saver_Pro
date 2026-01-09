//
//  WPGroupNameListViewModel.swift
//  WTScan
//
//  Created by iMac on 17/11/25.
//

import Combine
import UIKit

class WPGroupNameListViewModel: ObservableObject {
    
    let groupCategory: WPGroupCategory
    
    init(groupCategory: WPGroupCategory) {
        self.groupCategory = groupCategory
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnCopyAction(groupName: String) {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let _ = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            UIPasteboard.general.string = groupName
            WTToastManager.shared.show("Group name copied to clipboard")
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
}
