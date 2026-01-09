//
//  NavigationDestination.swift
//  WTScan
//
//  Created by IMac on 11/11/25.
//

import SwiftUI

enum NavigationDestination: Hashable {
    case directMessage
    case textRepeater
    case stylishText
    case emojiText
    case clipboardTemplate
    
    case qrCodeHome
    case qrCodeGenerator(option: WTQROption)
    
    case qrScanner
    case qrScanResult(qrText: String)
    
    case messageCounter
    case statusCaption
    case statusCaptionList(captionCategory: WTCaptionCategory)
    
    case fontStyling
    case wpGroupNameHome
    case wpGroupNameList(groupCategory: WPGroupCategory)
    
    case fakeChatPreviewGenerator
    case fakeChatPreview(messagePreview: MessagePreviewModel)
    
    case messageSchedulerReminderHome
    case messageSchedulerReminder
    
    case textCaseConverter
    case countdownStatusGenerator
    
    case settings
    case aboutApp
}
