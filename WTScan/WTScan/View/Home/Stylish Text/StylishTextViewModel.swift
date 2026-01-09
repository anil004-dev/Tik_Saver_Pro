//
//  StylishTextViewModel.swift
//  WTScan
//
//  Created by iMac on 12/11/25.
//


import Combine
import Foundation
import UIKit

struct TextStyle: Identifiable {
    let id = UUID()
    let name: String
    let transform: (String) -> String
}

class StylishTextViewModel: ObservableObject {
    
    @Published var enteredText: String = ""
    @Published var selectedStyle: TextStyle?
    
    @Published var arrStyles: [TextStyle] = [
        .init(name: "Bold", transform: { $0.toBold() }),
        .init(name: "Italic", transform: { $0.toItalic() }),
        .init(name: "Monospace", transform: { $0.toMonospace() }),
        .init(name: "Bubble", transform: { $0.toBubble() }),
        .init(name: "Double Struck", transform: { $0.toDoubleStruck() }),
        .init(name: "Fraktur", transform: { $0.toFraktur() }),
        .init(name: "Small Caps", transform: { $0.toSmallCaps() }),
        .init(name: "Superscript", transform: { $0.toSuperscript() }),
        .init(name: "Upside Down", transform: { $0.toUpsideDown() }),
        .init(name: "Mirror Text", transform: { $0.toMirrorText() }),
        .init(name: "Outline", transform: { $0.toOutline() }),
        .init(name: "Strike-through", transform: { $0.toStrikeThrough() }),
        .init(name: "Underline", transform: { $0.toUnderline() }),
        .init(name: "Tiny Text", transform: { $0.toTinyText() }),
        .init(name: "Inverted Case", transform: { $0.invertedCase() }),
    ]
    
    @Published var showShareSheetView: Bool = false

    
    // MARK: - Actions
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnSelectTexStyle(style: TextStyle) {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.selectedStyle = style
            self.copySelectedText()
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnShareAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.showShareSheetView = true
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnCopyAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.copySelectedText()
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func copySelectedText() {
        UIPasteboard.general.string = getTextToCopy()
        WTToastManager.shared.show("Message copied to clipboard")
    }
    
    func getTextToCopy() -> String {
        let enteredText = (enteredText.isEmpty ? "Hello" : enteredText)
        return selectedStyle?.transform(enteredText) ?? enteredText
    }
}
