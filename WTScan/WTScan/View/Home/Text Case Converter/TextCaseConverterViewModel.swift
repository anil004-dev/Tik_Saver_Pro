//
//  TextCaseConverterViewModel.swift
//  WTScan
//
//  Created by iMac on 17/11/25.
//

import Combine
import UIKit

enum ConverterTextCase: String, CaseIterable, Identifiable {
    case titleCase       = "Title Case"
    case sentenceCase    = "Sentence Case"
    case upperCase       = "UPPER CASE"
    case lowerCase       = "lower case"
    case firstLetter     = "First Letter"
    case alternatingCase = "Alternating Case"
    case toggleCase      = "Toggle Case"
    
    var id: String { rawValue }
}


class TextCaseConverterViewModel: ObservableObject {
    
    @Published var enteredText: String = ""
    @Published var showShareSheetView: Bool = false
    @Published var selectedCase: ConverterTextCase? = nil
        
    // MARK: - Actions
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnShareAction() {
        guard !enteredText.isEmpty else { return }
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.showShareSheetView = true
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnCopyAction() {
        guard !enteredText.isEmpty else { return }
        
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            UIPasteboard.general.string = self.enteredText
            WTToastManager.shared.show("Text copied to clipboard")
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnConvertTextCaseAction(textCase: ConverterTextCase) {
        let text = enteredText
        var finalText = ""
        
        switch textCase {
            
        case .titleCase:
            finalText = text
                .lowercased()
                .split(separator: " ")
                .map { $0.prefix(1).uppercased() + $0.dropFirst() }
                .joined(separator: " ")
            
        case .sentenceCase:
            finalText = text.sentenceCased()
            
        case .upperCase:
            finalText = text.uppercased()
            
        case .lowerCase:
            finalText = text.lowercased()
            
        case .firstLetter:
            finalText = text.lowercased().capitalizingFirstLetter()
            
        case .alternatingCase:
            finalText = text.alternatingCase()
            
        case .toggleCase:
            finalText = text.toggleCase()
        }
        
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.enteredText = finalText
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
                self.selectedCase = textCase
            }
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
}
