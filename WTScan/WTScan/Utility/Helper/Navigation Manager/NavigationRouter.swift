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
        case .aboutApp:
            AboutAppView()
        case .directMessage:
            DirectMessageView()
        case .textRepeater:
            TextRepeaterView()
        case .stylishText:
            StylishTextView()
        case .emojiText:
            EmojiTextView()
        case .clipboardTemplate:
            ClipboardTemplateView()
        case .qrCodeHome:
            QRCodeHomeView()
        case .qrCodeGenerator(let qrOption):
            QRGeneratorView(qrOption: qrOption)
        case .qrScanner:
            QRScannerView()
        case .qrScanResult(let qrText):
            QRScanResultView(qrText: qrText)
        case .messageCounter:
            MessageTextCounterView()
        case .statusCaption:
            StatusCaptionView()
        case .statusCaptionList(let quoteCategory):
            StatusCaptionListView(captionCategory: quoteCategory)
        case .fontStyling:
            FontStylingView()
        case .wpGroupNameHome:
            WPGroupNameHomeView()
        case .wpGroupNameList(let groupCategory):
            WPGroupNameListView(groupCategory: groupCategory)
        case .textCaseConverter:
            TextCaseConverterView()
        case .countdownStatusGenerator:
            CountdownStatusGeneratorView()
        case .fakeChatPreviewGenerator:
            FakeChatPreviewGeneratorView()
        case .fakeChatPreview(let messagePreview):
            FakeChatPreviewView(messagePreview: messagePreview)
        case .messageSchedulerReminderHome:
            MessageSchedulerHomeView()
        case .messageSchedulerReminder:
            MessageSchedulerReminderView()
        }
    }
}
