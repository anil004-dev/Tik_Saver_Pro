//
//  WPGroupNameHomeViewModel.swift
//  WTScan
//
//  Created by iMac on 17/11/25.
//

import Combine
import SwiftUI
import Foundation


class WPGroupNameHomeViewModel: ObservableObject {
    
    @Published var arrWPGroupCategories: [WPGroupCategory] = []
    @Published var randomGroupName: String?
    
    func onAppear() {
        arrWPGroupCategories = WPGroupCategory.loadGroupCategories()
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnGenerateRandomNameAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            withAnimation {
                self.randomGroupName = self.arrWPGroupCategories.flatMap { $0.names }.randomElement()
            }
        }
        
        InterstitialAdManager.shared.showAd()
    }
    
    func btnRemoveRandomNameAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            withAnimation {
                self.randomGroupName = nil
            }
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnCategoryAction(category: WPGroupCategory) {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let _ = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            NavigationManager.shared.push(to: .wpGroupNameList(groupCategory: category))
        }
        
        InterstitialAdManager.shared.increaseTapCount()
        
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
