//
//  QRGeneratorViewModel.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import Combine
import Foundation
import UIKit

class QRGeneratorViewModel: ObservableObject {
    
    let qrOption: WTQROption
    
    @Published var urlStr: String = ""
    
    @Published var name: String = ""
    @Published var mobile: String = ""
    @Published var email: String = ""
    @Published var address: String = ""
    @Published var organization: String = ""
    
    @Published var plainText: String = ""
    
    @Published var phoneNumberStr: String = ""
    @Published var message: String = ""
    
    @Published var latitude: String = ""
    @Published var longitude: String = ""
    
    @Published var merchatName: String = ""
    @Published var upiID: String = ""
    @Published var amount: String = ""
    @Published var note: String = ""
    
    @Published var ssid: String = ""
    @Published var password: String = ""
    @Published var securityType: String = "WPA"

    @Published var showShareSheetView: (sheet: Bool, qrImage: UIImage?) = (false, nil)
    
    init(qrOption: WTQROption) {
        self.qrOption = qrOption
    }
    
    func showShareSheet(qrImage: UIImage) {
        showShareSheetView.qrImage = qrImage
        showShareSheetView.sheet = true
    }
    
    func generateQRCode(from stringData: String) {
        QRGenerator.shared.generate(from: stringData) { [weak self] qrImage in
            guard let self = self else { return }
            if let qrImage {
                if EntitlementManager.shared.hasPro {
                    self.showShareSheet(qrImage: qrImage)
                }
                else {
                    InterstitialAdManager.shared.didFinishedAd = { [weak self] in
                        guard let self = self else { return }
                        InterstitialAdManager.shared.didFinishedAd = nil
                        
                        self.showShareSheet(qrImage: qrImage)
                    }
                    
                    InterstitialAdManager.shared.showAd()
                }
            } else {
                WTAlertManager.shared.showAlert(title: "Something went wrong!", message: "Unable to generate a qr code.")
            }
        }
    }
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnGenerateQRCodeAction() {
        switch qrOption {
        case .url:
            generateURLQRCode()
        case .contactCard:
            generateContactCardQRCode()
        case .phoneNumber:
            generatePhoneNumberQRCode()
        case .wifiAddress:
            generateWiFiQRCode()
        case .email:
            generateEmailQRCode()
        case .plainText:
            generatePlainTextQRCode()
        case .smsMessage:
            generateSMSQRCode()
        case .geoLocation:
            generateGeoLocationQRCode()
        case .upiPayment:
            generateUPIQRCode()
        }
    }
    
    func generateURLQRCode() {
        let urlStr = urlStr.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !urlStr.isEmpty else {
            WTAlertManager.shared.showAlert(title: "URL required!", message: "Please enter a url.")
            return
        }
        
        generateQRCode(from: urlStr)
    }
    
    func generateContactCardQRCode() {
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines)
        let mobile = mobile.trimmingCharacters(in: .whitespacesAndNewlines)
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        let address = address.trimmingCharacters(in: .whitespacesAndNewlines)
        let organization = organization.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !name.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Name required!", message: "Please enter a name.")
            return
        }
        
        guard !mobile.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Mobile number required!", message: "Please enter a valid mobile number.")
            return
        }
        
        let vCardStr = """
            BEGIN:VCARD
            VERSION:3.0
            N:\(name)
            FN:\(name)
            ORG:\(organization)
            TEL;TYPE=CELL:\(mobile)
            EMAIL;TYPE=INTERNET:\(email)
            ADR;TYPE=HOME:;;\(address)
            END:VCARD
            """
        
        generateQRCode(from: vCardStr)
    }
    
    func generatePhoneNumberQRCode() {
        let phoneNumberStr = phoneNumberStr.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !phoneNumberStr.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Phone number required!", message: "Please enter a valid phone number.")
            return
        }
        
        generateQRCode(from: "tel:\(phoneNumberStr)")
    }
    
    func generateEmailQRCode() {
        let email = email.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !email.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Email required!", message: "Please enter an email.")
            return
        }
        
        generateQRCode(from: "mailto:\(email)")
    }
    
    func generatePlainTextQRCode() {
        let plainText = plainText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !plainText.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Text required!", message: "Please enter a text.")
            return
        }
        
        generateQRCode(from: plainText)
    }
    
    func generateSMSQRCode() {
        let phoneNumberStr = phoneNumberStr.trimmingCharacters(in: .whitespacesAndNewlines)
        let message = message.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !phoneNumberStr.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Phone number required!", message: "Please enter a valid phone number.")
            return
        }
        
        guard !message.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Message required!", message: "Please enter a message.")
            return
        }
        
        let encodedMessage = message.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
        generateQRCode(from: "sms:\(phoneNumberStr)?body=\(encodedMessage)")
    }
    
    func generateGeoLocationQRCode() {
        let latitude = latitude.trimmingCharacters(in: .whitespacesAndNewlines)
        let longitude = longitude.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !latitude.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Latitude required!", message: "Please enter a valid latitude.")
            return
        }
        
        guard !longitude.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Longitude required!", message: "Please enter a valid longitude.")
            return
        }
        
        generateQRCode(from: "geo:\(latitude),\(longitude)")
    }
    
    func generateUPIQRCode() {
        let upiID = upiID.trimmingCharacters(in: .whitespacesAndNewlines)
        let name = merchatName.trimmingCharacters(in: .whitespacesAndNewlines)
        let amount = amount.trimmingCharacters(in: .whitespacesAndNewlines)
        let note = note.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !upiID.isEmpty else {
            WTAlertManager.shared.showAlert(title: "UPI ID required!", message: "Please enter a valid UPI ID.")
            return
        }
        
        var components: [String] = []
        components.append("pa=\(upiID)")
        components.append("cu=INR")  // Currency must be present
        
        if !name.isEmpty {
            components.append("pn=\(name)")
        }
        if !amount.isEmpty {
            components.append("am=\(amount)")
        }
        if !note.isEmpty {
            components.append("tn=\(note)")
        }
        
        // Join the parameters with &
        let upiString = "upi://pay?" + components.joined(separator: "&")
        
        generateQRCode(from: upiString)
    }

    func generateWiFiQRCode() {
        let ssid = ssid.trimmingCharacters(in: .whitespacesAndNewlines)
        let password = password.trimmingCharacters(in: .whitespacesAndNewlines)
        let security = securityType   // "WPA", "WEP", "nopass"

        guard !ssid.isEmpty else {
            WTAlertManager.shared.showAlert(title: "SSID required!", message: "Please enter Wi-Fi SSID.")
            return
        }

        var wifiString = "WIFI:T:\(security);S:\(ssid);"

        if security != "nopass" {
            guard !password.isEmpty else {
                WTAlertManager.shared.showAlert(title: "Password required!", message: "Please enter Wi-Fi password.")
                return
            }
            wifiString += "P:\(password);"
        }

        wifiString += ";"

        generateQRCode(from: wifiString)
    }

}
