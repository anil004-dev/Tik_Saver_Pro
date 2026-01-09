//
//  TextRepeaterViewModel.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//


import Combine
import Foundation
import UIKit

class TextRepeaterViewModel: ObservableObject {
    
    @Published var enteredText: String = ""
    @Published var resultText: String = ""
    @Published var repeatCount: String = ""
    @Published var isAddNewLine: Bool = true
    @Published var isAddSpace: Bool = false
    
    @Published var showShareSheetView: Bool = false
        
    // MARK: - Actions
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnAddNewLineAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.isAddNewLine.toggle()
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnAddSpaceAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.isAddSpace.toggle()
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnRepeatAction() {
        Utility.hideKeyboard()
        
        let mainText = enteredText.trimmingCharacters(in: .whitespacesAndNewlines)
        let repeatCountStr = repeatCount.trimmingCharacters(in: .whitespacesAndNewlines)
        let repeatCount = Int(repeatCountStr) ?? 0
        let isAddNewLine = isAddNewLine
        let isAddSpace = isAddSpace
        
        guard !mainText.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Text required!", message: "Please enter a text.")
            return
        }
        
        guard repeatCount > 0 else {
            WTAlertManager.shared.showAlert(title: "Repeat frequiency required!", message: "Please enter a repeat frequiency.")
            return
        }
        
        var resultText = ""
        
        for _ in 1...repeatCount {
            var text = mainText
            if isAddSpace {
                text += " "
            }
            
            if isAddNewLine {
                text += "\n"
            }
            
            resultText += text
        }
        
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.resultText = resultText
        }
        
        InterstitialAdManager.shared.showAd()
    }
    
    func btnShareAction() {
        guard !resultText.isEmpty else { return }
        
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.showShareSheetView = true
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnCopyAction() {
        guard !resultText.isEmpty else { return }
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            UIPasteboard.general.string = self.resultText
            WTToastManager.shared.show("Message copied to clipboard")
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
}
