//
//  FakeChatPreviewGeneratorViewModel.swift
//  WTScan
//
//  Created by iMac on 21/11/25.
//

import UIKit
import Combine
import Foundation

struct MessagePreviewModel: Equatable, Hashable {
    let id = UUID()
    let profileImage: UIImage?
    let profileName: String
    let arrMessage: [Message]
}

struct Message: Equatable, Hashable {
    let id = UUID()
    let message: String
    let time: Date
    let isMyMessage: Bool
}

class FakeChatPreviewGeneratorViewModel: ObservableObject {
    
    @Published var profileImage: UIImage?
    @Published var profileName: String = "Avatar"
    
    @Published var messageText: String = ""
    @Published var messageTime: Date = Date.now
    @Published var messageSide: Int = 0
    
    @Published var arrMessage: [Message] = []
    @Published var showImagePicker: Bool = false
    
    func btnBackAction() {
        NavigationManager.shared.pop()
    }
    
    func btnAddMessage() {
        let message = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !message.isEmpty else {
            WTAlertManager.shared.showAlert(title: "Message is required", message: "Please enter a message")
            return
        }
        
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            let messageObj = Message(message: message, time: messageTime, isMyMessage: messageSide == 0)
            self.arrMessage.append(messageObj)
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnClearAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            self.profileImage = nil
            self.profileName = "Avatar"
            self.messageText = ""
            self.messageSide = 0
            self.messageTime = Date.now
            self.arrMessage = []
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnGenerateImageAction() {
        guard !arrMessage.isEmpty else {
            WTAlertManager.shared.showAlert(
                title: "No Messages Added",
                message: "Please add at least one message before generating the preview"
            )
            return
        }
        
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            let messagePreviewModel = MessagePreviewModel(profileImage: self.profileImage, profileName: self.profileName, arrMessage: self.arrMessage)
            NavigationManager.shared.push(to: .fakeChatPreview(messagePreview: messagePreviewModel))
        }
        
        InterstitialAdManager.shared.showAd()
    }
}
