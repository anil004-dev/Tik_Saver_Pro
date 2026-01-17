//
//  HomeViewModel.swift
//  WTScan
//
//  Created by iMac on 11/11/25.
//

/*import Combine
 
 class HomeViewModel: ObservableObject {
 
 lazy var arrOptions: [WTOptionModel] = [
 WTOptionModel(
 option: .directMessage,
 image: "paperplane.fill",
 title: "Direct Message",
 subTitle: "Send Message without\nSaving Number"
 ),
 
 WTOptionModel(
 option: .textRepeater,
 image: "paperplane.fill",
 title: "Text Repeater",
 subTitle: "Fun spamming in chat"
 ),
 
 WTOptionModel(
 option: .stylishText,
 image: "paperplane.fill",
 title: "Stylish Text",
 subTitle: "Convert normal text\ninto fancy styles"
 ),
 
 WTOptionModel(
 option: .emojiText,
 image: "paperplane.fill",
 title: "Emoji Text",
 subTitle: "Convert letters into\nemoji-styled text"
 ),
 
 WTOptionModel(
 option: .clipboardManager,
 image: "paperplane.fill",
 title: "Clipboard Manager",
 subTitle: "Save frequently used\nmessages"
 ),
 
 WTOptionModel(
 option: .qrCodeGenerator,
 image: "paperplane.fill",
 title: "QR Code Generator",
 subTitle: "Generate QR codes\nfor text"
 ),
 
 WTOptionModel(
 option: .qrCodeScanner,
 image: "paperplane.fill",
 title: "QR Code Scanner",
 subTitle: "Scan QR codes\nusing camera"
 ),
 
 WTOptionModel(
 option: .messageCounter,
 image: "paperplane.fill",
 title: "Message Counter",
 subTitle: "Send direct message\nto anyone"
 ),
 
 WTOptionModel(
 option: .statusCaption,
 image: "paperplane.fill",
 title: "Status Caption",
 subTitle: "Fun spamming in chat"
 ),
 
 WTOptionModel(
 option: .fontStyling,
 image: "paperplane.fill",
 title: "Font Styling",
 subTitle: "Convert normal text to different styles"
 ),
 
 WTOptionModel(
 option: .whatsAppGroupNameGenerator,
 image: "paperplane.fill",
 title: "WhatsApp Group\nName Generator",
 subTitle: ""
 ),
 
 WTOptionModel(
 option: .fakeChatPreviewGenerator,
 image: "paperplane.fill",
 title: "Fake Chat Preview\nGenerator",
 subTitle: ""
 ),
 
 WTOptionModel(
 option: .messageSchedulerReminder,
 image: "paperplane.fill",
 title: "Message Scheduler\nReminder",
 subTitle: ""
 ),
 
 WTOptionModel(
 option: .textCaseConverter,
 image: "paperplane.fill",
 title: "Text Case\nConverter",
 subTitle: ""
 ),
 
 WTOptionModel(
 option: .countdownStatusGenerator,
 image: "paperplane.fill",
 title: "Countdown Status\nGenerator",
 subTitle: ""
 ),
 
 WTOptionModel(
 option: .stylishBioGenerator,
 image: "paperplane.fill",
 title: "Stylish Bio\nGenerator",
 subTitle: ""
 ),
 
 WTOptionModel(
 option: .nicknameGenerator,
 image: "paperplane.fill",
 title: "Nickname\nGenerator",
 subTitle: ""
 )
 ]
 
 var isFirstLanuch: Bool = true
 func onAppear() {
 
 if isFirstLanuch {
 isFirstLanuch = false
 btnOptionAction(optionModel: WTOptionModel(option: .messageSchedulerReminder, image: "", title: "", subTitle: "   "))
 }
 }
 
 func btnOptionAction(optionModel: WTOptionModel) {
 switch optionModel.option {
 case .none:
 print("\(optionModel.option)")
 case .directMessage:
 NavigationManager.shared.push(to: .directMessage)
 case .textRepeater:
 NavigationManager.shared.push(to: .textRepeater)
 case .stylishText:
 NavigationManager.shared.push(to: .stylishText)
 case .emojiText:
 NavigationManager.shared.push(to: .emojiText)
 case .clipboardManager:
 NavigationManager.shared.push(to: .clipboardTemplate)
 case .qrCodeGenerator:
 NavigationManager.shared.push(to: .qrCodeHome)
 case .qrCodeScanner:
 openQRCodeScanner()
 case .messageCounter:
 NavigationManager.shared.push(to: .messageCounter)
 case .statusCaption:
 NavigationManager.shared.push(to: .statusCaption)
 case .fontStyling:
 NavigationManager.shared.push(to: .fontStyling)
 case .whatsAppGroupNameGenerator:
 NavigationManager.shared.push(to: .wpGroupNameHome)
 case .fakeChatPreviewGenerator:
 NavigationManager.shared.push(to: .fakeChatPreviewGenerator)
 case .messageSchedulerReminder:
 NavigationManager.shared.push(to: .messageSchedulerReminderHome)
 case .textCaseConverter:
 NavigationManager.shared.push(to: .textCaseConverter)
 case .countdownStatusGenerator:
 NavigationManager.shared.push(to: .countdownStatusGenerator)
 case .stylishBioGenerator:
 break
 case .nicknameGenerator:
 break
 }
 }
 
 func openQRCodeScanner() {
 Utility.checkPermission { [weak self] isEnabled in
 guard let _ = self else { return }
 
 if isEnabled {
 NavigationManager.shared.push(to: .qrScanner)
 } else {
 Utility.showCameraDeniedAlert()
 }
 }
 }
 }
 */


import Combine
import Foundation
import AVFoundation
import UIKit
import _PhotosUI_SwiftUI

struct WTOptionSection {
    var id: UUID = UUID()
    let title: String
    let rows: [WTOptionModel]
}

class HomeViewModel: ObservableObject {
    
    var arrSections: [WTOptionSection] {
        [
            WTOptionSection(
                title: "Messaging",
                rows: AppState.shared.isLive ?  [
                    WTOptionModel(
                        option: .directMessage,
                        image: .icDirectMessage,
                        title: "Direct Message",
                        subTitle: "Send Message without Saving Number"
                    ),
                    
                    WTOptionModel(
                        option: .messageSchedulerReminder,
                        image: .icMessageSchedulerReminder,
                        title: "Message Scheduler Reminder",
                        subTitle: "Schedule reminders for important messages"
                    ),
                    
                    WTOptionModel(
                        option: .fakeChatPreviewGenerator,
                        image: .icChatPreviewGenerator,
                        title: "Chat Preview Generator",
                        subTitle: "Create a mock chat layout for fun"
                    ),
                    
                    
                    WTOptionModel(
                        option: .messageCounter,
                        image: .icMessageCounter,
                        title: "Message Counter",
                        subTitle: "Send direct message to anyone"
                    )
                ] :
                    [
                        WTOptionModel(
                            option: .messageSchedulerReminder,
                            image: .icMessageSchedulerReminder,
                            title: "Message Scheduler Reminder",
                            subTitle: "Schedule reminders for important messages"
                        ),
                        
                        WTOptionModel(
                            option: .messageCounter,
                            image: .icMessageCounter,
                            title: "Message Counter",
                            subTitle: "Live character counter for your messages"
                        ),
                        
                        WTOptionModel(
                            option: .repost,
                            image: .icArrowSquarepath,
                            title: "Repost",
                            subTitle: "Repost your content to any social media"
                        )
                    ]
            ),
            
            WTOptionSection(
                title: "QR",
                rows: [
                    WTOptionModel(
                        option: .qrCodeGenerator,
                        image: .icQrCodeGenerator,
                        title: "QR Code Generator",
                        subTitle: "Generate QR codes for text"
                    ),
                    
                    WTOptionModel(
                        option: .qrCodeScanner,
                        image: .icQrCodeScanner,
                        title: "QR Code Scanner",
                        subTitle: "Scan QR codes using camera"
                    )
                ]
            ),
            
            WTOptionSection(
                title: "Text Magic",
                rows: [
                    WTOptionModel(
                        option: .stylishText,
                        image: .icConvertFancyFont,
                        title: "Stylish text",
                        subTitle: "Convert normal text into fancy styles"
                    ),
                    
                    WTOptionModel(
                        option: .fontStyling,
                        image: .icFontStyling,
                        title: "Font Styling",
                        subTitle: "Convert normal text to different styles"
                    ),
                    
                    WTOptionModel(
                        option: .emojiText,
                        image: .icEmojiText,
                        title: "Emoji Text",
                        subTitle: "Convert letters into emoji-styled text"
                    ),
                    
                    WTOptionModel(
                        option: .textRepeater,
                        image: .icTextRepeater,
                        title: "Text Repeater",
                        subTitle: "Generate repeated text instantly"
                    ),
                    
                    WTOptionModel(
                        option: .textCaseConverter,
                        image: .icTextCaseConverter,
                        title: "Text Case Converter",
                        subTitle: ""
                    ),
                    
                    WTOptionModel(
                        option: .clipboardManager,
                        image: .icClipboardText,
                        title: "Clipboard Manager",
                        subTitle: "Save frequently used messages"
                    ),
                ]
            ),
            
            WTOptionSection(
                title: "Creative Generators",
                rows: [
                    WTOptionModel(
                        option: .statusCaption,
                        image: .icStatusCaption,
                        title: "Status Caption",
                        subTitle: ""
                    ),
                    
                    WTOptionModel(
                        option: .whatsAppGroupNameGenerator,
                        image: .icWhatsappGroupNameGenerator,
                        title: "Group Name Generator",
                        subTitle: ""
                    ),
                    
                    
                    WTOptionModel(
                        option: .countdownStatusGenerator,
                        image: .icCountdownStatusGenerator,
                        title: "Countdown Status Generator",
                        subTitle: ""
                    )
                ]
            )
        ]
    }
    
    @Published var showShareSheetView: (sheet: Bool, url: URL?) = (false, nil)
    @Published var isPresentPhotoPicker: Bool = false
    
    // MARK: - Inputs
    @Published var selectedItem: PhotosPickerItem? = nil {
        didSet {
            // Automatically trigger load when selection changes
            if let item = selectedItem {
                loadMedia(from: item)
            }
        }
    }
    @Published private var selectedImage: UIImage? = nil
    @Published private var selectedVideoURL: URL? = nil
    
    var isFirstLanuch: Bool = true
    func onAppear() {
        
        if isFirstLanuch {
            isFirstLanuch = false
            //btnOptionAction(optionModel: WTOptionModel(option: .countdownStatusGenerator, image: .icAppIcon, title: "", subTitle: ""))
        }
    }
    
    // MARK: - Load Logic
    @MainActor
    func loadMedia(from item: PhotosPickerItem) {
        WTLoader.show()
        self.selectedImage = nil
        self.selectedVideoURL = nil
        
        Task {
            // 1. Try Loading as Video (Movie)
            // We try video first because some Live Photos might match both, but we usually prefer the video file if explicitly picked as video.
            // However, PhotosPicker usually distinguishes them well.
            do {
                if let movie = try await item.loadTransferable(type: Movie.self) {
                    self.selectedVideoURL = movie.url
                    WTLoader.dismiss()
                    NavigationManager.shared.push(to: .repost(selectedImage: selectedImage, selectedVideoURL: selectedVideoURL))
                    self.selectedItem = nil
                    return
                }
                else if let data = try await item.loadTransferable(type: Data.self),
                        let uiImage = UIImage(data: data) {
                    self.selectedImage = uiImage
                    WTLoader.dismiss()
                    NavigationManager.shared.push(to: .repost(selectedImage: selectedImage, selectedVideoURL: selectedVideoURL))
                    self.selectedItem = nil
                    return
                }
                else {
                    WTLoader.dismiss()
                }
            } catch {
                print("Failed to load video: \(error.localizedDescription)")
                WTLoader.dismiss()
            }
            // 3. Fallback / Failure
            
            print("Could not load media from item")
        }
    }
    
    func btnOptionAction(optionModel: WTOptionModel) {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            switch optionModel.option {
            case .none:
                print("\(optionModel.option)")
            case .directMessage:
                NavigationManager.shared.push(to: .directMessage)
            case .textRepeater:
                NavigationManager.shared.push(to: .textRepeater)
            case .repost:
                isPresentPhotoPicker = true
                //NavigationManager.shared.push(to: .repost)
            case .stylishText:
                NavigationManager.shared.push(to: .stylishText)
            case .emojiText:
                NavigationManager.shared.push(to: .emojiText)
            case .clipboardManager:
                NavigationManager.shared.push(to: .clipboardTemplate)
            case .qrCodeGenerator:
                NavigationManager.shared.push(to: .qrCodeHome)
            case .qrCodeScanner:
                self.openQRCodeScanner()
            case .messageCounter:
                NavigationManager.shared.push(to: .messageCounter)
            case .statusCaption:
                NavigationManager.shared.push(to: .statusCaption)
            case .fontStyling:
                NavigationManager.shared.push(to: .fontStyling)
            case .whatsAppGroupNameGenerator:
                NavigationManager.shared.push(to: .wpGroupNameHome)
            case .fakeChatPreviewGenerator:
                NavigationManager.shared.push(to: .fakeChatPreviewGenerator)
            case .messageSchedulerReminder:
                NavigationManager.shared.push(to: .messageSchedulerReminderHome)
            case .textCaseConverter:
                NavigationManager.shared.push(to: .textCaseConverter)
            case .countdownStatusGenerator:
                NavigationManager.shared.push(to: .countdownStatusGenerator)
            }
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func openQRCodeScanner() {
        Utility.requestCameraPermission { [weak self] isGranted in
            guard let _ = self, isGranted else { return }
            NavigationManager.shared.push(to: .qrScanner)
        }
    }
    
    func btnSettingAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let _ = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            NavigationManager.shared.push(to: .settings)
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
    
    func btnShareAction() {
        InterstitialAdManager.shared.didFinishedAd = { [weak self] in
            guard let self = self else { return }
            InterstitialAdManager.shared.didFinishedAd = nil
            
            if let appURL = URL(string: WTConstant.appURL) {
                self.showShareSheetView.url = appURL
                self.showShareSheetView.sheet = true
            }
        }
        
        InterstitialAdManager.shared.increaseTapCount()
    }
}

import AVKit
import PhotosUI
import CoreTransferable

struct Movie: Transferable {
    let url: URL
    
    static var transferRepresentation: some TransferRepresentation {
        FileRepresentation(contentType: .movie) { movie in
            SentTransferredFile(movie.url)
        } importing: { received in
            let fileName = received.file.lastPathComponent
            let copy = URL.documentsDirectory.appending(path: fileName)
            
            if FileManager.default.fileExists(atPath: copy.path()) {
                try? FileManager.default.removeItem(at: copy)
            }
            
            try FileManager.default.copyItem(at: received.file, to: copy)
            return Self.init(url: copy)
        }
    }
}
