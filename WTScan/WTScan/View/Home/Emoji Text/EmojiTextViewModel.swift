//
//  EmojiTextViewModel.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import Combine
import UIKit

class EmojiTextViewModel: ObservableObject {
    
    @Published var enteredText: String = ""
    @Published var emojiText: String = "😃"
    @Published var resultText: String = ""
    
    @Published var showShareSheetView: Bool = false
        
    // MARK: - Actions
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnConvertAction() {
        Utility.hideKeyboard()
        
        let text = enteredText.trimmingCharacters(in: .whitespacesAndNewlines)
        let emoji = emojiText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !text.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Text required!", message: "Please enter a text.")
            return
        }
        
        guard !emoji.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Emoji required!", message: "Please enter an emoji.")
            return
        }
        
        var resultEmojiText = ""
        let alphabetList = getAlphaBetList()
        let emojiList = getEmojiList()
        
        for char in text.uppercased() {
            if let index = alphabetList.firstIndex(of: String(char)) {
                let pattern = emojiList[index]
                    .replacingOccurrences(of: "m", with: emoji)
                    .replacingOccurrences(of: " ", with: "  ") // keeps width even
                resultEmojiText += pattern + "\n\n"
            }
        }
        
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.resultText = resultEmojiText
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
    
    func getEmojiList() -> [String] {
        var arrayLatters: [String] = []
        arrayLatters.append("       m\n    m  m\n    m m m\n   m       m\nm         m")
        arrayLatters.append("mmmm\nm          m\nmmmm\nm          m\nmmmm")
        arrayLatters.append("\n    mmm\n m         m\nm\n m         m\n    mmm\n")
        arrayLatters.append("mmmm\nm          m\nm            m\nm          m\nmmmm")
        arrayLatters.append("mmmm\nm\nmmm\nm\nmmmm")
        arrayLatters.append("mmmm\nm\nmmm\nm\nm")
        arrayLatters.append(" mmm\n m\nm       mm\n m        m\n    mmm")
        arrayLatters.append("m         m\nm         m\nmmmm\nm         m\nm         m")
        arrayLatters.append("mmm\n      m\n      m\n      m\nmmm")
        arrayLatters.append("   mmm\n        m\n        m\nm    m\n  mm")
        arrayLatters.append("m     m\nm   m\nmm\nm   m\nm     m")
        arrayLatters.append("m\nm\nm\nm\nmmmm")
        arrayLatters.append("m           m\nm m   m m\nm      m    m\nm           m\nm           m")
        arrayLatters.append("m          m\nm m       m\nm    m    m\nm      m m\nm          m")
        arrayLatters.append("   mmm\n m        m\nm         m\n m        m\n   mmm")
        arrayLatters.append("mmmm\nm         m\nmmmm\nm\nm\n")
        arrayLatters.append("   mmm\n m        m\nm    m m\n m       m\n  mmm m")
        arrayLatters.append("mmmm\nm         m\nmmmm\nm    m\nm      m\n")
        arrayLatters.append("  mmm\n m\n  mmm\n           m\n  mmm")
        arrayLatters.append("mmmm\n      m\n      m\n      m\n      m")
        arrayLatters.append("m         m\n m        m\n m        m\n  m       m\n   mmm")
        arrayLatters.append("\nm        m\n m     m\n   m   m\n     m m\n     m")
        arrayLatters.append("m        m        m\n m     m m     m\n  m   m    m   m\n   m m       m m\n     m           m")
        arrayLatters.append("m      m\n   m m\n     m\n   m m\nm      m")
        arrayLatters.append("m      m\n   m m\n     m\n     m\n     m")
        arrayLatters.append("mmmm\n         m\n       m\n   m\nmmmm")
        arrayLatters.append("  mm\nm  m\n      m\n  mmm")
        arrayLatters.append(" mmm\nm     m\n      m\n   m\n mmm")
        arrayLatters.append("mmm\n         m\n    mm\n         m\nmmm")
        arrayLatters.append("         m\n    m m\n  m    m\nmmmm\n         m")
        arrayLatters.append("mmm\nm\n mmm\n         m\nmmm")
        arrayLatters.append(" mmm\nm\nmmm\nm      m\n mmm")
        arrayLatters.append("mmm\n        m\n      m\n    m\n   m")
        arrayLatters.append(" mmm\nm      m\n mmm\nm      m\n mmm")
        arrayLatters.append(" mmm\nm     m\n mmm\n        m\n   mm")
        arrayLatters.append("   mmm\n m        m\nm         m\n m        m\n   mmm")
        return arrayLatters
    }
    
    func getAlphaBetList() -> [String] {
        return "A,B,C,D,E,F,G,H,I,J,K,L,M,N,O,P,Q,R,S,T,U,V,W,X,Y,Z".components(separatedBy: ",")
    }
}
