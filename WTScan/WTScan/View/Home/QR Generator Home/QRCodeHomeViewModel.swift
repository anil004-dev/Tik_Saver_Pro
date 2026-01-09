//
//  QRCodeHomeViewModel.swift
//  WTScan
//
//  Created by iMac on 13/11/25.
//

import Combine
import SwiftUI

class QRCodeHomeViewModel: ObservableObject {
 
    let arrQROptions: [WTQROptionModel] = [
        WTQROptionModel(option: .url, imageName: "link", imageSize: .init(width: 25, height: 25), title: "URL"),
        WTQROptionModel(option: .contactCard, imageName: "phone.fill", imageSize: .init(width: 25, height: 25), title: "Contact Card"),
        WTQROptionModel(option: .phoneNumber, imageName: "person.text.rectangle.fill", imageSize: .init(width: 25, height: 20), title: "Phone Number"),
        WTQROptionModel(option: .wifiAddress, imageName: "wifi", imageSize: .init(width: 25, height: 18), title: "Wi-Fi Address"),
        WTQROptionModel(option: .email, imageName: "envelope", imageSize: .init(width: 25, height: 18), title: "Email"),
        WTQROptionModel(option: .plainText, imageName: "text.page.fill", imageSize: .init(width: 22, height: 28), title: "Plain Text"),
        WTQROptionModel(option: .smsMessage, imageName: "bubble.fill", imageSize: .init(width: 25, height: 23), title: "SMS Message"),
        WTQROptionModel(option: .geoLocation, imageName: "mappin.and.ellipse", imageSize: .init(width: 25, height: 25), title: "Geo Location"),
        WTQROptionModel(option: .upiPayment, imageName: "link", imageSize: .init(width: 25, height: 20), title: "UPI Payment"),
    ]
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnQROptionAction(optionModel: WTQROptionModel) {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let _ = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            NavigationManager.shared.push(to: .qrCodeGenerator(option: optionModel.option))
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
}
