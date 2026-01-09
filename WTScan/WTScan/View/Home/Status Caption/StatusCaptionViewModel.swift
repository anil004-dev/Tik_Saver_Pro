//
//  StatusCaptionViewModel.swift
//  WTScan
//
//  Created by iMac on 14/11/25.
//

import Combine

class StatusCaptionViewModel: ObservableObject {
    
    @Published var arrCaptionCategory: [WTCaptionCategory] = []
    
    init() {
        arrCaptionCategory = WTCaptionCategory.loadCaptionsCategory()
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnCaptionCategoryAction(category: WTCaptionCategory) {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let _ = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            NavigationManager.shared.push(to: .statusCaptionList(captionCategory: category))
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
}
