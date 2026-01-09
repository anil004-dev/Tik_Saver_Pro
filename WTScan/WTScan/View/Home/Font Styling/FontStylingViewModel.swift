//
//  FontStylingViewModel.swift
//  WTScan
//
//  Created by iMac on 17/11/25.
//

import UIKit
import Combine
import Foundation

class FontStylingViewModel: ObservableObject {
    
    @Published var arrFontStyles: [String] = []
    @Published var enteredText: String = ""
    
    @Published var showShareSheetView: (sheet: Bool, text: String?) = (false, nil)
    
    func onAppear() {
        if let path = Bundle.main.path(forResource: "FontStyle", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let jsonResult = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                if let jsonResult = jsonResult as? [String] {
                    arrFontStyles = jsonResult
                }
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    func getFontStyleText(fontStyle: String) -> String {
        let arrayCharactor = fontStyle.components(separatedBy: "~~~")
        let enteredText = enteredText.isEmpty ? "Preview" : enteredText
        
        var displayString: String = ""
        
        for newChat in enteredText {
            let chatIndex: Int = Utility.getCharactorIndex(char: newChat)
            if chatIndex == -1 {
                displayString.append(" ")
            }
            else {
                displayString.append(arrayCharactor[chatIndex])
            }
        }
        
        return displayString
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnShareAction(text: String) {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.showShareSheetView.text = text
            self.showShareSheetView.sheet = true
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnCopyAction(text: String) {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let _ = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            UIPasteboard.general.string = text
            WTToastManager.shared.show("Text copied to clipboard")
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
}
