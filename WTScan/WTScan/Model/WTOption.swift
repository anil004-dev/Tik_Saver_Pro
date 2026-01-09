//
//  WTOption.swift
//  WTScan
//
//  Created by iMac on 12/11/25.
//

import SwiftUI

enum WTOption {
    case none
    case directMessage
    case textRepeater
    case stylishText
    case emojiText
    case clipboardManager
    case qrCodeGenerator
    case qrCodeScanner
    case messageCounter
    case statusCaption
    case fontStyling
    case whatsAppGroupNameGenerator
    case fakeChatPreviewGenerator
    case messageSchedulerReminder
    case textCaseConverter
    case countdownStatusGenerator
}

struct WTOptionModel {
    let id = UUID()
    let option: WTOption
    let image: ImageResource
    var isSystemImage: Bool = true
    let title: String
    let subTitle: String
}
