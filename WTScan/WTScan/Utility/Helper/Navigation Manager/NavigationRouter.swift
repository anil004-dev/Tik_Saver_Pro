//
//  NavigationRouter.swift
//  WTScan
//
//  Created by IMac on 11/11/25.
//

import SwiftUI
import Combine

enum NavigationRouter {
    
    @ViewBuilder
    static func destinationView(for navDestination: NavigationDestination) -> some View {
        switch navDestination {
        case .settings:
            SettingsView()
                .toolbar(.hidden, for: .tabBar)
        case .aboutApp:
            AboutAppView()
                .toolbar(.hidden, for: .tabBar)
        case .directMessage:
            DirectMessageView()
                .toolbar(.hidden, for: .tabBar)
        case .textRepeater:
            TextRepeaterView()
                .toolbar(.hidden, for: .tabBar)
        case .stylishText:
            StylishTextView()
                .toolbar(.hidden, for: .tabBar)
        case .emojiText:
            EmojiTextView()
                .toolbar(.hidden, for: .tabBar)
        case .clipboardTemplate:
            ClipboardTemplateView()
                .toolbar(.hidden, for: .tabBar)
        case .qrCodeHome:
            QRCodeHomeView()
                .toolbar(.hidden, for: .tabBar)
        case .qrCodeGenerator(let qrOption):
            QRGeneratorView(qrOption: qrOption)
                .toolbar(.hidden, for: .tabBar)
        case .qrScanner:
            QRScannerView()
                .toolbar(.hidden, for: .tabBar)
        case .qrScanResult(let qrText):
            QRScanResultView(qrText: qrText)
                .toolbar(.hidden, for: .tabBar)
        case .messageCounter:
            MessageTextCounterView()
                .toolbar(.hidden, for: .tabBar)
        case .statusCaption:
            StatusCaptionView()
                .toolbar(.hidden, for: .tabBar)
        case .statusCaptionList(let quoteCategory):
            StatusCaptionListView(captionCategory: quoteCategory)
                .toolbar(.hidden, for: .tabBar)
        case .fontStyling:
            FontStylingView()
                .toolbar(.hidden, for: .tabBar)
        case .wpGroupNameHome:
            WPGroupNameHomeView()
                .toolbar(.hidden, for: .tabBar)
        case .wpGroupNameList(let groupCategory):
            WPGroupNameListView(groupCategory: groupCategory)
                .toolbar(.hidden, for: .tabBar)
        case .textCaseConverter:
            TextCaseConverterView()
                .toolbar(.hidden, for: .tabBar)
        case .countdownStatusGenerator:
            CountdownStatusGeneratorView()
                .toolbar(.hidden, for: .tabBar)
        case .fakeChatPreviewGenerator:
            FakeChatPreviewGeneratorView()
                .toolbar(.hidden, for: .tabBar)
        case .fakeChatPreview(let messagePreview):
            FakeChatPreviewView(messagePreview: messagePreview)
                .toolbar(.hidden, for: .tabBar)
        case .messageSchedulerReminderHome:
            MessageSchedulerHomeView()
                .toolbar(.hidden, for: .tabBar)
        case .messageSchedulerReminder:
            MessageSchedulerReminderView()
                .toolbar(.hidden, for: .tabBar)
        case .repost(let selectedImage, let selectedVideoURL):
            RepostView(image: selectedImage, videoURL: selectedVideoURL)
                .toolbar(.hidden, for: .tabBar)
        }
    }
}
