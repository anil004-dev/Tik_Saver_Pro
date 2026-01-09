//
//  WTQROption.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import Foundation

enum WTQROption: String, CaseIterable, Identifiable {
    case url = "URL"
    case contactCard = "Contact Card"
    case phoneNumber = "Phone Number"
    case wifiAddress = "Wi-Fi Address"
    case email = "Email"
    case plainText = "Plain Text"
    case smsMessage = "SMS Message"
    case geoLocation = "Geo Location"
    case upiPayment = "UPI Payment"
    
    var id: String { return rawValue }
}

struct WTQROptionModel {
    let id: UUID = UUID()
    let option: WTQROption
    
    let imageName: String
    let imageSize: CGSize
    let title: String
}
