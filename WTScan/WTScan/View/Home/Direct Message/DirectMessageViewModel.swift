//
//  DirectMessageViewModel.swift
//  WTScan
//
//  Created by iMac on 12/11/25.
//

import Combine
import Foundation
import UIKit

enum DirectMessageTextCase: String, CaseIterable, Identifiable {
    case SentenceCase = "Sentence case"
    case loweCase = "lower case"
    case upperCase = "UPPER CASE"
    case capitalizeCase = "Capitalize Case"
    case titleCase = "Title Case"
    case copy = "Copy"
    
    var id: String { rawValue }
}

class DirectMessageViewModel: ObservableObject {
    
    @Published var phoneNumber: String = ""
    @Published var message: String = ""
    
    @Published var selectedCountry: Country?
    
    @Published var showCountryPickerView: Bool = false
    
    @Published var selectedCase: DirectMessageTextCase? = nil
    
    init() {
        Task { @MainActor in
            selectedCountry = Country.init(countryCode: "IN")
        }
    }
    
    // MARK: - Actions
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnCountryPickerAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.showCountryPickerView = true
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnTextCaseAction(selectedCase: DirectMessageTextCase) {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            var message = self.message.trimmingCharacters(in: .whitespacesAndNewlines)
            if selectedCase == .copy && message.isEmpty == true {
                return
            }
            
            self.selectedCase = selectedCase
            
            switch selectedCase {
            case .SentenceCase:
                message = message.lowercased()
                if let first = message.first {
                    message = first.uppercased() + message.dropFirst()
                }
                
            case .loweCase:
                message = message.lowercased()
                
            case .upperCase:
                message = message.uppercased()
                
            case .capitalizeCase:
                // Capitalize each word (Swift’s built-in function)
                message = message.capitalized
                
            case .titleCase:
                // Title case (capitalize important words only)
                let minorWords = ["a", "an", "and", "as", "at", "but", "by", "for", "in", "nor", "of", "on", "or", "the", "to", "up", "is"]
                message = message
                    .lowercased()
                    .split(separator: " ")
                    .enumerated()
                    .map { index, word in
                        if index == 0 || !minorWords.contains(word.lowercased()) {
                            return word.capitalized
                        } else {
                            return word.lowercased()
                        }
                    }
                    .joined(separator: " ")
                
            case .copy:
                UIPasteboard.general.string = message
                WTToastManager.shared.show("Message copied to clipboard")
                return // No need to assign back to message
            }
            
            self.message = message
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }

    
    func btnSendAction() {
        Utility.hideKeyboard()

        
        Task { @MainActor in
            var phoneNumber = phoneNumber.trimmingCharacters(in: .whitespacesAndNewlines)
            let message = message.trimmingCharacters(in: .whitespacesAndNewlines)
            
            do {
                let phoneNumberKit = PhoneNumberKit()
                let formattedNumber = try phoneNumberKit.parse(phoneNumber)
                let countryCode = "\(formattedNumber.countryCode)"
                let countryCodeCount = countryCode.count
                var phoneNumberString = phoneNumberKit.format(formattedNumber, toType: .e164)
                
                if phoneNumberString.hasPrefix(countryCode) {
                    phoneNumberString = String(phoneNumberString.dropFirst(countryCodeCount))
                } else if phoneNumberString.hasPrefix("+\(formattedNumber.countryCode)") {
                    phoneNumberString = String(phoneNumberString.dropFirst(countryCodeCount+1))
                }
                
                DispatchQueue.main.async {
                    self.selectedCountry = CountryManager.shared.country(withCode: formattedNumber.regionID ?? "")
                    self.phoneNumber = phoneNumberString
                    
                    phoneNumber = phoneNumberString
                }
            } catch {
                WTAlertManager.shared.showAlert(title: "Oops!", message: error.localizedDescription)
                return
            }
            
            guard let countryCode = selectedCountry?.dialingCode else {
                WTAlertManager.shared.showAlert(title: "Country required!", message: "Please select a country.")
                return
            }
            
            guard !phoneNumber.isEmpty else {
                WTAlertManager.shared.showAlert(title: "Phone number required!", message: "Please enter a phone number.")
                return
            }
            
            guard !message.isEmpty else {
                WTAlertManager.shared.showAlert(title: "Message required!", message: "Please enter a message.")
                return
            }
            
            var characterSet = CharacterSet.urlQueryAllowed
            characterSet.insert(charactersIn: "?&")
            
            guard let urlString = "https://api.whatsapp.com/send?phone=\(countryCode+phoneNumber)&text=\(message)".addingPercentEncoding(withAllowedCharacters: characterSet), let wpURL = URL(string: urlString), UIApplication.shared.canOpenURL(wpURL) else {
                WTAlertManager.shared.showAlert(title: "Something went wrong!", message: "Unable to send message.")
                return
            }
            
            print(wpURL)
            
            InterstitialAdManager.shared.didFinishedAd = { [weak self] in
                guard let _ = self else { return }
                InterstitialAdManager.shared.didFinishedAd = nil
                UIApplication.shared.open(wpURL)
            }
            
            InterstitialAdManager.shared.showAd()
        }
    }
}
